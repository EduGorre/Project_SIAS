function [] = default_settings()
% MODIFY DEFAULT SETTINGS IN MATLAB (run only once at session startup)

% The following is a set of commands that can be helpful to maintain a
% fixed style and format for all your figures. They set some default
% properties of the graphics root object of the Matlab renderer. Note that
% these settings are maintained throughout the Matlab session, until it is
% restarted, so this script should be run only once.

% This command sets the size of the ticks on the axes. 
set(groot, 'defaultLegendFontSize', 12);
% This command sets the default size of the text appearing in the figure in
% axes labels and titles
set(groot, 'defaultTextFontSize', 12);
% This command sets the default axes font size. If you set this, the legend
% fontsize is adjusted to be 0.9 of this value, while the other labels
% fontsize becomes 1/0.9 times this value. If you want to use the same font
% size for all objects (titles, labels, legend, axis ticks), then you must 
% specify the fontsize for the label/legend in each individual figure
set(groot, 'defaultAxesFontSize', 12);

% This command sets the width of the axes
set(groot, 'defaultAxesLineWidth', 1);
% These commands activate or not the minor ticks of the axes
set(groot, 'defaultAxesXMinorTick', 'on');
set(groot, 'defaultAxesYMinorTick', 'on');
% This command deactivates the legend by default
set(groot, 'defaultLegendBox', 'off');
% This command defines the default position of the legend
set(groot, 'defaultLegendLocation', 'best');
% This command defines the default line width in the  plots
set(groot, 'defaultLineLineWidth', 1);
% This command defines the default line marker size
set(groot, 'defaultLineMarkerSize', 5);
% This command sets the font of the axes ticks to Latex
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
% This command defines the font for the default text for the rest of
% objects (labels, titles, legend, etc...)
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% % Additional settings to have a predefined size of the figure (not used
% % here. You might be interested in using them)
% aurea=1.61803398875; % aurea ratio for nice plots
% mydocwidth=16.56;    % width for A4 pages
% % change default units
% set(groot,'DefaultFigurePaperUnits','centimeters')
% set(groot,'DefaultFigureUnits','centimeters')
% % set position
% paperpositionmydoc = [0 0 mydocwidth mydocwidth/aurea];
% % set paper size for (important for pdf files)
% set(groot,'DefaultFigurePaperSize',[mydocwidth mydocwidth/aurea])
% % set paper position
% set(groot,'DefaultFigurePaperPosition',[0 0 mydocwidth mydocwidth/aurea])
% % use bigger fonts (default is 12)
end