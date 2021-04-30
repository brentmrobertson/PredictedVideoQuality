
load('predictionCoefficients.mat')

figure
title('All Data')
xlabel('Actual PSNR')
ylabel('Predicted PSNR')
legend('Location', 'southeast')
hold on
scatter(round(BlueY), round(modelFun(BlueBeta, BlueX)), [], 'b', '+', 'DisplayName', 'Group 1')
scatter(round(GreenY), round(modelFun(GreenBeta, GreenX)), [], [0 .5 0], 'x', 'DisplayName', 'Group 2')
scatter(round(PurpleY), round(modelFun(PurpleBeta, PurpleX)), [], [.5 0 1], 'd', 'DisplayName', 'Group 3')
scatter(round(RedY), round(modelFun(RedBeta, RedX)), [], 'r', 'o', 'DisplayName', 'Group 4')
plot(10:45, 10:45, 'k', 'DisplayName', '1:1','HandleVisibility','off')
axis square
hold off


figure
title('Group 1')
xlabel('Actual PSNR')
ylabel('Predicted PSNR')
legend('Location', 'southeast')
hold on
scatter(round(BlueY), round(modelFun(BlueBeta, BlueX)), [], 'b', '+', 'DisplayName', 'Group 1')
plot(10:45, 10:45, 'k', 'DisplayName', '1:1','HandleVisibility','off')
axis square
hold off


figure
title('Group 2')
xlabel('Actual PSNR')
ylabel('Predicted PSNR')
legend('Location', 'southeast')
hold on
scatter(round(GreenY), round(modelFun(GreenBeta, GreenX)), [], [0 .5 0], 'x', 'DisplayName', 'Group 2')
plot(10:45, 10:45, 'k', 'DisplayName', '1:1','HandleVisibility','off')
axis square
hold off


figure
title('Group 3')
xlabel('Actual PSNR')
ylabel('Predicted PSNR')
legend('Location', 'southeast')
hold on
scatter(round(PurpleY), round(modelFun(PurpleBeta, PurpleX)), [], [.5 0 1], 'd', 'DisplayName', 'Group 3')
plot(10:45, 10:45, 'k', 'DisplayName', '1:1','HandleVisibility','off')
axis square
hold off


figure
title('Group 4')
xlabel('Actual PSNR')
ylabel('Predicted PSNR')
legend('Location', 'southeast')
hold on
scatter(round(RedY), round(modelFun(RedBeta, RedX)), [], 'r', 'o', 'DisplayName', 'Group 4')
plot(10:45, 10:45, 'k', 'DisplayName', '1:1','HandleVisibility','off')
axis square
hold off


FrameRateTable = table(...
    [   mean(modelFun(BlueBeta, BlueX(:,BlueX(1,:) == 30))-BlueY(BlueX(1,:) == 30)) + ...
        " (" + std(modelFun(BlueBeta, BlueX(:,BlueX(1,:) == 30))-BlueY(BlueX(1,:) == 30)) + ")"; ...
        mean(modelFun(BlueBeta, BlueX(:,BlueX(1,:) == 60))-BlueY(BlueX(1,:) == 60)) + ...
        " (" + std(modelFun(BlueBeta, BlueX(:,BlueX(1,:) == 60))-BlueY(BlueX(1,:) == 60)) + ")"], ...
    [   mean(modelFun(GreenBeta, GreenX(:,GreenX(1,:) == 30))-GreenY(GreenX(1,:) == 30)) + ...
        " (" + std(modelFun(GreenBeta, GreenX(:,GreenX(1,:) == 30))-GreenY(GreenX(1,:) == 30)) + ")"; ...
        mean(modelFun(GreenBeta, GreenX(:,GreenX(1,:) == 60))-GreenY(GreenX(1,:) == 60)) + ...
        " (" + std(modelFun(GreenBeta, GreenX(:,GreenX(1,:) == 60))-GreenY(GreenX(1,:) == 60)) + ")"], ...
    [   mean(modelFun(PurpleBeta, PurpleX(:,PurpleX(1,:) == 30))-PurpleY(PurpleX(1,:) == 30)) + ...
        " (" + std(modelFun(PurpleBeta, PurpleX(:,PurpleX(1,:) == 30))-PurpleY(PurpleX(1,:) == 30)) + ")"; ...
        mean(modelFun(PurpleBeta, PurpleX(:,PurpleX(1,:) == 60))-PurpleY(PurpleX(1,:) == 60)) + ...
        " (" + std(modelFun(PurpleBeta, PurpleX(:,PurpleX(1,:) == 60))-PurpleY(PurpleX(1,:) == 60)) + ")"], ...
    [   mean(modelFun(RedBeta, RedX(:,RedX(1,:) == 30))-RedY(RedX(1,:) == 30)) + ...
        " (" + std(modelFun(RedBeta, RedX(:,RedX(1,:) == 30))-RedY(RedX(1,:) == 30)) + ")"; ...
        mean(modelFun(RedBeta, RedX(:,RedX(1,:) == 60))-RedY(RedX(1,:) == 60)) + ...
        " (" + std(modelFun(RedBeta, RedX(:,RedX(1,:) == 60))-RedY(RedX(1,:) == 60)) + ")"], ...
    'VariableNames', {'Group_1_Videos', 'Group_2_Videos', 'Group_3_Videos', 'Group_4_Videos'}, ...
    'RowNames', {'30 fps', '60 fps'})

BitrateTable = table(...
    [   mean(modelFun(BlueBeta, BlueX(:,BlueX(2,:) == 3000))-BlueY(BlueX(2,:) == 3000)) + ...
        " (" + std(modelFun(BlueBeta, BlueX(:,BlueX(2,:) == 3000))-BlueY(BlueX(2,:) == 3000)) + ")"; ...
        mean(modelFun(BlueBeta, BlueX(:,BlueX(2,:) == 5000))-BlueY(BlueX(2,:) == 5000)) + ...
        " (" + std(modelFun(BlueBeta, BlueX(:,BlueX(2,:) == 5000))-BlueY(BlueX(2,:) == 5000)) + ")"], ...
    [   mean(modelFun(GreenBeta, GreenX(:,GreenX(2,:) == 3000))-GreenY(GreenX(2,:) == 3000)) + ...
        " (" + std(modelFun(GreenBeta, GreenX(:,GreenX(2,:) == 3000))-GreenY(GreenX(2,:) == 3000)) + ")"; ...
        mean(modelFun(GreenBeta, GreenX(:,GreenX(2,:) == 5000))-GreenY(GreenX(2,:) == 5000)) + ...
        " (" + std(modelFun(GreenBeta, GreenX(:,GreenX(2,:) == 5000))-GreenY(GreenX(2,:) == 5000)) + ")"], ...
    [   mean(modelFun(PurpleBeta, PurpleX(:,PurpleX(2,:) == 3000))-PurpleY(PurpleX(2,:) == 3000)) + ...
        " (" + std(modelFun(PurpleBeta, PurpleX(:,PurpleX(2,:) == 3000))-PurpleY(PurpleX(2,:) == 3000)) + ")"; ...
        mean(modelFun(PurpleBeta, PurpleX(:,PurpleX(2,:) == 5000))-PurpleY(PurpleX(2,:) == 5000)) + ...
        " (" + std(modelFun(PurpleBeta, PurpleX(:,PurpleX(2,:) == 5000))-PurpleY(PurpleX(2,:) == 5000)) + ")"], ...
    [   mean(modelFun(RedBeta, RedX(:,RedX(2,:) == 3000))-RedY(RedX(2,:) == 3000)) + ...
        " (" + std(modelFun(RedBeta, RedX(:,RedX(2,:) == 3000))-RedY(RedX(2,:) == 3000)) + ")"; ...
        mean(modelFun(RedBeta, RedX(:,RedX(2,:) == 5000))-RedY(RedX(2,:) == 5000)) + ...
        " (" + std(modelFun(RedBeta, RedX(:,RedX(2,:) == 5000))-RedY(RedX(2,:) == 5000)) + ")"], ...
    'VariableNames', {'Group_1_Videos', 'Group_2_Videos', 'Group_3_Videos', 'Group_4_Videos'}, ...
    'RowNames', {'3 mbps', '5 mbps'})

PacketErrorTable = table(...
    [   mean(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0))-BlueY(BlueX(3,:) == 0)) + ...
        " (" + std(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0))-BlueY(BlueX(3,:) == 0)) + ")"; ...
        mean(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.01))-BlueY(BlueX(3,:) == 0.01)) + ...
        " (" + std(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.01))-BlueY(BlueX(3,:) == 0.01)) + ")"; ...
        mean(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.05))-BlueY(BlueX(3,:) == 0.05)) + ...
        " (" + std(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.05))-BlueY(BlueX(3,:) == 0.05)) + ")"; ...
        mean(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.10))-BlueY(BlueX(3,:) == 0.10)) + ...
        " (" + std(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.10))-BlueY(BlueX(3,:) == 0.10)) + ")"; ...
        mean(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.15))-BlueY(BlueX(3,:) == 0.15)) + ...
        " (" + std(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.15))-BlueY(BlueX(3,:) == 0.15)) + ")"; ...
        mean(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.20))-BlueY(BlueX(3,:) == 0.20)) + ...
        " (" + std(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.20))-BlueY(BlueX(3,:) == 0.20)) + ")"], ...
    [   mean(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0))-GreenY(GreenX(3,:) == 0)) + ...
        " (" + std(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0))-GreenY(GreenX(3,:) == 0)) + ")"; ...
        mean(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.01))-GreenY(GreenX(3,:) == 0.01)) + ...
        " (" + std(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.01))-GreenY(GreenX(3,:) == 0.01)) + ")"
        mean(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.05))-GreenY(GreenX(3,:) == 0.05)) + ...
        " (" + std(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.05))-GreenY(GreenX(3,:) == 0.05)) + ")"
        mean(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.10))-GreenY(GreenX(3,:) == 0.10)) + ...
        " (" + std(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.10))-GreenY(GreenX(3,:) == 0.10)) + ")"
        mean(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.15))-GreenY(GreenX(3,:) == 0.15)) + ...
        " (" + std(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.15))-GreenY(GreenX(3,:) == 0.15)) + ")"
        mean(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.20))-GreenY(GreenX(3,:) == 0.20)) + ...
        " (" + std(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.20))-GreenY(GreenX(3,:) == 0.20)) + ")"], ...
    [   mean(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0))-PurpleY(PurpleX(3,:) == 0)) + ...
        " (" + std(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0))-PurpleY(PurpleX(3,:) == 0)) + ")"; ...
        mean(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.01))-PurpleY(PurpleX(3,:) == 0.01)) + ...
        " (" + std(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.01))-PurpleY(PurpleX(3,:) == 0.01)) + ")"
        mean(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.05))-PurpleY(PurpleX(3,:) == 0.05)) + ...
        " (" + std(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.05))-PurpleY(PurpleX(3,:) == 0.05)) + ")"
        mean(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.10))-PurpleY(PurpleX(3,:) == 0.10)) + ...
        " (" + std(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.10))-PurpleY(PurpleX(3,:) == 0.10)) + ")"
        mean(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.15))-PurpleY(PurpleX(3,:) == 0.15)) + ...
        " (" + std(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.15))-PurpleY(PurpleX(3,:) == 0.15)) + ")"
        mean(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.20))-PurpleY(PurpleX(3,:) == 0.20)) + ...
        " (" + std(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.20))-PurpleY(PurpleX(3,:) == 0.20)) + ")"], ...
    [   mean(modelFun(RedBeta, RedX(:,RedX(3,:) == 0))-RedY(RedX(3,:) == 0)) + ...
        " (" + std(modelFun(RedBeta, RedX(:,RedX(3,:) == 0))-RedY(RedX(3,:) == 0)) + ")"; ...
        mean(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.01))-RedY(RedX(3,:) == 0.01)) + ...
        " (" + std(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.01))-RedY(RedX(3,:) == 0.01)) + ")"
        mean(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.05))-RedY(RedX(3,:) == 0.05)) + ...
        " (" + std(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.05))-RedY(RedX(3,:) == 0.05)) + ")"
        mean(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.10))-RedY(RedX(3,:) == 0.10)) + ...
        " (" + std(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.10))-RedY(RedX(3,:) == 0.10)) + ")"
        mean(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.15))-RedY(RedX(3,:) == 0.15)) + ...
        " (" + std(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.15))-RedY(RedX(3,:) == 0.15)) + ")"
        mean(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.20))-RedY(RedX(3,:) == 0.20)) + ...
        " (" + std(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.20))-RedY(RedX(3,:) == 0.20)) + ")"], ...
    'VariableNames', {'Group_1_Videos', 'Group_2_Videos', 'Group_3_Videos', 'Group_4_Videos'}, ...
    'RowNames', {'0%', '1%', '5%', '10%', '15%', '20%'})

%figure
%title('30 fps')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(round(BlueY(BlueX(1,:) == 30)), round(modelFun(BlueBeta, BlueX(:,BlueX(1,:) == 30))), [], 'k', '+', 'DisplayName', 'Group 1')
%scatter(round(GreenY(GreenX(1,:) == 30)), round(modelFun(GreenBeta, GreenX(:,GreenX(1,:) == 30))), [], 'k', 'x', 'DisplayName', 'Group 2')
%scatter(round(PurpleY(PurpleX(1,:) == 30)), round(modelFun(PurpleBeta, PurpleX(:,PurpleX(1,:) == 30))), [], 'k', 'd', 'DisplayName', 'Group 3')
%scatter(round(RedY(RedX(1,:) == 30)), round(modelFun(RedBeta, RedX(:,RedX(1,:) == 30))), [], 'k', 'o', 'DisplayName', 'Group 4')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('60 fps')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(round(BlueY(BlueX(1,:) == 60)), round(modelFun(BlueBeta, BlueX(:,BlueX(1,:) == 60))), [], 'k', '+', 'DisplayName', 'Group 1')
%scatter(round(GreenY(GreenX(1,:) == 60)), round(modelFun(GreenBeta, GreenX(:,GreenX(1,:) == 60))), [], 'k', 'x', 'DisplayName', 'Group 2')
%scatter(round(PurpleY(PurpleX(1,:) == 60)), round(modelFun(PurpleBeta, PurpleX(:,PurpleX(1,:) == 60))), [], 'k', 'd', 'DisplayName', 'Group 3')
%scatter(round(RedY(RedX(1,:) == 60)), round(modelFun(RedBeta, RedX(:,RedX(1,:) == 60))), [], 'k', 'o', 'DisplayName', 'Group 4')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('3 Mbps - All Groups')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(round(BlueY(BlueX(2,:) == 3000)), round(modelFun(BlueBeta, BlueX(:,BlueX(2,:) == 3000))), [], 'k', '+', 'DisplayName', 'Group 1')
%scatter(round(GreenY(GreenX(2,:) == 3000)), round(modelFun(GreenBeta, GreenX(:,GreenX(2,:) == 3000))), [], 'k', 'x', 'DisplayName', 'Group 2')
%scatter(round(PurpleY(PurpleX(2,:) == 3000)), round(modelFun(PurpleBeta, PurpleX(:,PurpleX(2,:) == 3000))), [], 'k', 'd', 'DisplayName', 'Group 3')
%scatter(round(RedY(RedX(2,:) == 3000)), round(modelFun(RedBeta, RedX(:,RedX(2,:) == 3000))), [], 'k', 'o', 'DisplayName', 'Group 4')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('5 Mbps - All Groups')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(round(BlueY(BlueX(2,:) == 5000)), round(modelFun(BlueBeta, BlueX(:,BlueX(2,:) == 5000))), [], 'k', '+', 'DisplayName', 'Group 1')
%scatter(round(GreenY(GreenX(2,:) == 5000)), round(modelFun(GreenBeta, GreenX(:,GreenX(2,:) == 5000))), [], 'k', 'x', 'DisplayName', 'Group 2')
%scatter(round(PurpleY(PurpleX(2,:) == 5000)), round(modelFun(PurpleBeta, PurpleX(:,PurpleX(2,:) == 5000))), [], 'k', 'd', 'DisplayName', 'Group 3')
%scatter(round(RedY(RedX(2,:) == 5000)), round(modelFun(RedBeta, RedX(:,RedX(2,:) == 5000))), [], 'k', 'o', 'DisplayName', 'Group 4')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('3 Mbps - Group 1')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(BlueY(BlueX(2,:) == 3000), modelFun(BlueBeta, BlueX(:,BlueX(2,:) == 3000)), [], 'k', '+', 'DisplayName', 'Group 1')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('5 Mbps - Group 1')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(BlueY(BlueX(2,:) == 5000), modelFun(BlueBeta, BlueX(:,BlueX(2,:) == 5000)), [], 'k', '+', 'DisplayName', 'Group 1')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('3 Mbps - Group 2')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(GreenY(GreenX(2,:) == 3000), modelFun(GreenBeta, GreenX(:,GreenX(2,:) == 3000)), [], 'k', 'x', 'DisplayName', 'Group 2')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('5 Mbps - Group 2')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(GreenY(GreenX(2,:) == 5000), modelFun(GreenBeta, GreenX(:,GreenX(2,:) == 5000)), [], 'k', 'x', 'DisplayName', 'Group 2')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('3 Mbps - Group 3')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(PurpleY(PurpleX(2,:) == 3000), modelFun(PurpleBeta, PurpleX(:,PurpleX(2,:) == 3000)), [], 'k', 'd', 'DisplayName', 'Group 3')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('5 Mbps - Group 3')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(PurpleY(PurpleX(2,:) == 5000), modelFun(PurpleBeta, PurpleX(:,PurpleX(2,:) == 5000)), [], 'k', 'd', 'DisplayName', 'Group 3')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('3 Mbps - Group 4')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(RedY(RedX(2,:) == 3000), modelFun(RedBeta, RedX(:,RedX(2,:) == 3000)), [], 'k', 'o', 'DisplayName', 'Group 4')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('5 Mbps - Group 4')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(RedY(RedX(2,:) == 5000), modelFun(RedBeta, RedX(:,RedX(2,:) == 5000)), [], 'k', 'o', 'DisplayName', 'Group 4')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('0% PER')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(round(BlueY(BlueX(3,:) == 0)), round(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0))), [], 'k', '+', 'DisplayName', 'Group 1')
%scatter(round(GreenY(GreenX(3,:) == 0)), round(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0))), [], 'k', 'x', 'DisplayName', 'Group 2')
%scatter(round(PurpleY(PurpleX(3,:) == 0)), round(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0))), [], 'k', 'd', 'DisplayName', 'Group 3')
%scatter(round(RedY(RedX(3,:) == 0)), round(modelFun(RedBeta, RedX(:,RedX(3,:) == 0))), [], 'k', 'o', 'DisplayName', 'Group 4')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('1% PER')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(round(BlueY(BlueX(3,:) == 0.01)), round(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.01))), [], 'k', '+', 'DisplayName', 'Group 1')
%scatter(round(GreenY(GreenX(3,:) == 0.01)), round(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.01))), [], 'k', 'x', 'DisplayName', 'Group 2')
%scatter(round(PurpleY(PurpleX(3,:) == 0.01)), round(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.01))), [], 'k', 'd', 'DisplayName', 'Group 3')
%scatter(round(RedY(RedX(3,:) == 0.01)), round(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.01))), [], 'k', 'o', 'DisplayName', 'Group 4')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('5% PER')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(round(BlueY(BlueX(3,:) == 0.05)), round(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.05))), [], 'k', '+', 'DisplayName', 'Group 1')
%scatter(round(GreenY(GreenX(3,:) == 0.05)), round(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.05))), [], 'k', 'x', 'DisplayName', 'Group 2')
%scatter(round(PurpleY(PurpleX(3,:) == 0.05)), round(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.05))), [], 'k', 'd', 'DisplayName', 'Group 3')
%scatter(round(RedY(RedX(3,:) == 0.05)), round(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.05))), [], 'k', 'o', 'DisplayName', 'Group 4')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('10% PER')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(round(BlueY(BlueX(3,:) == 0.10)), round(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.10))), [], 'k', '+', 'DisplayName', 'Group 1')
%scatter(round(GreenY(GreenX(3,:) == 0.10)), round(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.10))), [], 'k', 'x', 'DisplayName', 'Group 2')
%scatter(round(PurpleY(PurpleX(3,:) == 0.10)), round(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.10))), [], 'k', 'd', 'DisplayName', 'Group 3')
%scatter(round(RedY(RedX(3,:) == 0.10)), round(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.10))), [], 'k', 'o', 'DisplayName', 'Group 4')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('15% PER')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(round(BlueY(BlueX(3,:) == 0.15)), round(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.15))), [], 'k', '+', 'DisplayName', 'Group 1')
%scatter(round(GreenY(GreenX(3,:) == 0.15)), round(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.15))), [], 'k', 'x', 'DisplayName', 'Group 2')
%scatter(round(PurpleY(PurpleX(3,:) == 0.15)), round(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.15))), [], 'k', 'd', 'DisplayName', 'Group 3')
%scatter(round(RedY(RedX(3,:) == 0.15)), round(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.15))), [], 'k', 'o', 'DisplayName', 'Group 4')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
%
%
%figure
%title('20% PER')
%xlabel('Actual PSNR')
%ylabel('Predicted PSNR')
%legend('Location', 'southeast')
%hold on
%scatter(round(BlueY(BlueX(3,:) == 0.20)), round(modelFun(BlueBeta, BlueX(:,BlueX(3,:) == 0.20))), [], 'k', '+', 'DisplayName', 'Group 1')
%scatter(round(GreenY(GreenX(3,:) == 0.20)), round(modelFun(GreenBeta, GreenX(:,GreenX(3,:) == 0.20))), [], 'k', 'x', 'DisplayName', 'Group 2')
%scatter(round(PurpleY(PurpleX(3,:) == 0.20)), round(modelFun(PurpleBeta, PurpleX(:,PurpleX(3,:) == 0.20))), [], 'k', 'd', 'DisplayName', 'Group 3')
%scatter(round(RedY(RedX(3,:) == 0.20)), round(modelFun(RedBeta, RedX(:,RedX(3,:) == 0.20))), [], 'k', 'o', 'DisplayName', 'Group 4')
%plot(10:45, 10:45, 'k', 'DisplayName', '1:1')
%hold off
