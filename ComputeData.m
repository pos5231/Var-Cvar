function[VaR,CVaR,VaRn,CVaRn] = ComputeData(PLData,alf,n)

% Number of historical scenarios
N = size(PLData,1);

% Sort loss data in increasing order
loss_1d = sort(-PLData);

% Compute Historical 1-day VaR from the data
VaR  = loss_1d(ceil(N*alf));
% Compute Historical 1-day CVaR from the data
CVaR = (1/(N*(1-alf))) * ( (ceil(N*alf)-N*alf) * VaR + sum(loss_1d(ceil(N*alf)+1:N)) );

last = loss_1d(end);
% Compute Normal 1-day VaR from the data
VaRn = mean(loss_1d) + norminv(alf,0,1)*std(loss_1d);
% Compute Normal 1-day CVaR from the data
CVaRn = mean(loss_1d) + (normpdf(norminv(alf,0,1))/(1-alf))*std(loss_1d);

% Plot a histogram of the distribution of losses in portfolio value
figure(n)
set(gcf, 'color', 'white');
[frequencyCounts, binLocations] = hist(loss_1d, 100);
bar(binLocations, frequencyCounts);
hold on;
line([VaR VaR], [0 max(frequencyCounts)], 'Color', 'm', 'LineWidth', 3, 'LineStyle', '--');
hold on;
normf = ( 1/(std(loss_1d)*sqrt(2*pi)) ) * exp( -0.5*((binLocations-mean(loss_1d))/std(loss_1d)).^2 );
normf = normf * sum(frequencyCounts)/sum(normf);
plot(binLocations, normf, 'g', 'LineWidth', 3);
hold on;
line([VaRn VaRn], [0 max(frequencyCounts)/2], 'Color', 'k', 'LineWidth', 3, 'LineStyle', ':');
hold on;
x = [VaR, last,last,VaR];
y = [0,0,max(frequencyCounts)*1.1,max(frequencyCounts)*1.1];
patch(x,y,'red','FaceAlpha',.2)
xlabel('Loss')
ylabel('Frequency')
legend('Histogram','VaR','Normal Disribution','VaRn','CVaR Range')
hold off