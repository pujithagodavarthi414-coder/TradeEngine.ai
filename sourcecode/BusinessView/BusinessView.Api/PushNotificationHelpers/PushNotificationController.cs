using BusinessView.Common;
using BusinessView.DAL;
using Microsoft.Azure.NotificationHubs;
using System;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;

namespace BusinessView.Api.PushNotificationHelpers
{
    public static class PushNotificationController
    {
        public static async Task SendNotificationToReciever(int recieverId, int senderid)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    var senderDetails = await entities.Users.Where(x => x.Id == senderid).FirstOrDefaultAsync();

                    if (senderDetails != null)
                    {
                        NotificationHubClient hub = NotificationHubClient.CreateClientFromConnectionString(PushNotificationConstants.ConnectionString, PushNotificationConstants.HubName);

                        var androidNotification = "{ \"data\" : {\"message\":\"" + "New Message from " + senderDetails.Name + "\",\"Id\":\"" + senderDetails.Id + "\",\"Name\":\"" + senderDetails.Name + "\",\"NotificationType\":\"" + "onetoone" + "\"}}";

                        var iosNotification = "{ \"aps\" : {\"alert\":\"" + "New Message from " + senderDetails.Name + "\",\"Id\":\"" + senderDetails.Id + "\",\"Name\":\"" + senderDetails.Name + "\",\"NotificationType\":\"" + "onetoone" + "\"}}";

                        await hub.SendGcmNativeNotificationAsync(androidNotification, recieverId.ToString());
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
            }
        }

        public static async Task SendChannelMessageNotification(int senderId, int channelId)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    var channelDetails = await entities.Channels.Where(x => x.Id == channelId).FirstOrDefaultAsync();

                    if(channelDetails!=null)
                    {
                        var senderDetails = await entities.Users.Where(x => x.Id == senderId).FirstOrDefaultAsync();

                        if(senderDetails!=null)
                        {
                            var channelMembersList = await entities.ChannelMembers.Where(x => x.ChannelId == channelId && x.ActiveTo==null).ToListAsync();

                            if(channelMembersList.Count>0)
                            {
                                foreach(var member in channelMembersList)
                                {
                                    if(member.MemberUserId!=senderDetails.Id)
                                    {
                                        NotificationHubClient hub = NotificationHubClient.CreateClientFromConnectionString(PushNotificationConstants.ConnectionString, PushNotificationConstants.HubName);

                                        var androidNotification = "{ \"data\" : {\"message\":\"" + "New Message from " + senderDetails.Name + " in " + channelDetails.ChannelName + "\",\"ChannelId\":\"" + channelDetails.Id + "\",\"ChannelName\":\"" + channelDetails.ChannelName + "\",\"NotificationType\":\"" + "channelMessage" + "\"}}";

                                        var iosNotification = "{ \"aps\" : {\"alert\":\"" + "New Message from " + senderDetails.Name + " in " + channelDetails.ChannelName + "\",\"ChannelId\":\"" + channelDetails.Id + "\",\"ChannelName\":\"" + channelDetails.ChannelName + "\",\"NotificationType\":\"" + "channelMessage" + "\"}}";

                                        await hub.SendGcmNativeNotificationAsync(androidNotification, member.Id.ToString());
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
            }
        }
    }
}