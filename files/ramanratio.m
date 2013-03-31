function [ratio] = ramanratio(N, I, IAfter)
	siLowerBound = 500;
	siUpperBound = 540;
	gLowerBound = 1500;
	gUpperBound = 1700;
	twoDLowerBound = 2400;
	twoDUpperBound = 3000;
	A = importdata(N);
	
	%Check if images are specified.
	if (exist('I') ~= 0)
		image = imread(I);
	end
	if (exist('IAfter') ~= 0)
		imageAfter = imread(IAfter);
	end

	x = A(:,1);
	y = A(:,2);
	siPeak = [,];
	gPeak = [,];
	twoDPeak = [,];

	%Find Si peak
	for i=1:numel(x)
		if (x(i) > siLowerBound & x(i) < siUpperBound)
			xy = [x(i),y(i)];
			siPeak = [siPeak;xy];
		end
	end

	%Find G peak
	for i=1:numel(x)
		if (x(i) > gLowerBound & x(i) < gUpperBound)
			xy = [x(i),y(i)];
			gPeak = [gPeak;xy];
		end
	end

	%Find 2D peak
	for i=1:numel(x)
		if (x(i) > twoDLowerBound & x(i) < twoDUpperBound)
			xy = [x(i),y(i)];
			twoDPeak = [twoDPeak;xy];
		end
	end

	%Find maxima
	siMax = max(siPeak(:,2))
	gMax = max(gPeak(:,2))
	twoDMax = max(twoDPeak(:,2))

	%Calculate ratio 
	ratio = gMax/siMax

	%Plot
	hFig = figure(1);
	rows = 2
	
	% If both images are present.
	if (exist('I')~=0 & exist('IAfter')~=0)
		columns = 4;
		ramanLocation = [2 4];
		siLocation = 6;
		gLocation = 7;
		twoDLocation = 8;

		imshow(image, 'Parent', subplot('Position', [0 0.55 0.3 0.4]));
		text(320, -15, 'Before');
		imshow(imageAfter, 'Parent', subplot('Position', [0 0.05 0.3 0.4]));
		text(350, -15, 'After');
	%If only one image is present.
	elseif (exist('I')~=0)
		columns = 4;
		ramanLocation = [2 4];
		siLocation = 6;
		gLocation = 7;
		twoDLocation = 8;
		imageSub = subplot(rows,columns,[1 5]);
		imshow(image, 'Parent', imageSub);
		set(imageSub, 'Position', [0 0.3 0.3 0.4]);
	%If no images are present.
	else 
		columns = 3;
		ramanLocation = [1 3];
		siLocation = 4;
		gLocation = 5;
		twoDLocation = 6;
	end

	set(hFig, 'Position', [100 200 1000 500]);

	subplot(rows,columns,ramanLocation), plot(x,y);
	grid on; xlabel('Raman Shift (cm^{-1})'); ylabel('Intensity (a.u.)'); 
	title('Raman Spectrum', 'FontWeight', 'bold');
	subplot(rows,columns,siLocation), plot(siPeak(:,1), siPeak(:,2));
	grid on; xlabel('Raman Shift (cm^{-1})'); ylabel('Intensity (a.u.)'); 
	title('Si Peak', 'FontWeight', 'bold');
	subplot(rows,columns,gLocation), plot(gPeak(:,1), gPeak(:,2));
	grid on; xlabel('Raman Shift (cm^{-1})'); ylabel('Intensity (a.u.)'); 
	title('G Peak', 'FontWeight', 'bold');
	subplot(rows,columns,twoDLocation), plot(twoDPeak(:,1), twoDPeak(:,2));
	grid on; xlabel('Raman Shift (cm^{-1})'); ylabel('Intensity (a.u.)'); 
	title('2D Peak', 'FontWeight', 'bold');

	ratioString = num2str(ratio);
	annotation('textbox', [0.88 0.5 0 0], 'String', 
		strcat('Ratio (I_{G}/I_{Si}):  ',ratioString));

	%Set subplot title to folder name.
	currentDirectory = pwd;
	[upperPath, deepestFolder, ~] = fileparts(currentDirectory);
	suptitle(deepestFolder);


