using System.Collections.Generic;
using Btrak.Models.Chat;
using BTrak.Common;

namespace Btrak.Services.PubNub
{
    public interface IPubNubService
    {
        void PublishMessageToChannel(string messageJson, List<string> channelNames,LoggedInContext loggedInContext);
        void PublishUserUpdatesToChannel(string message, List<string> pubNubChannels, LoggedInContext loggedInContext);
        void PublishReportsToChannel(string channelName, string message, LoggedInContext loggedInContext);
        void PublishPushNotificationToChannel(MessageDto messageDto,List<string> channelNames,LoggedInContext loggedInContext);

        void PublishLunchStartStatusOfUser(LoggedInContext loggedInContext, string hostAddress, int retryCount = 10);
        void PublishStartStatusOfUser(LoggedInContext loggedInContext,string hostAddress, int retryCount = 10);
        void PublishLunchEndStatusOfUser(LoggedInContext loggedInContext, string hostAddress, int retryCount = 10);
        void PublishBreakStartStatusOfUser(LoggedInContext loggedInContext, string hostAddress, int retryCount = 10);
        void PublishBreakEndStatusOfUser(LoggedInContext loggedInContext, string hostAddress, int retryCount = 10);
        void PublishFinishStatusOfUser(LoggedInContext loggedInContext, string hostAddress, int retryCount = 10);
    }
}