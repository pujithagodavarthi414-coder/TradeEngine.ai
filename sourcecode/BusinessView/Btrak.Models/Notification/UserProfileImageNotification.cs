using BTrak.Common;
using BTrak.Common.Constants;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Notification
{
    public class UserProfileImageNotification : NotificationBase
    {
        public string ProfileImage { get; set; }
        public Guid? UserId { get; set; }

        public UserProfileImageNotification(string profileImage, Guid? userId) : base(NotificationTypeConstants.UserProfileImageUpdate, profileImage)
        {
            ProfileImage = profileImage;
            UserId = userId;
            Channels.Add(string.Format(NotificationChannelNamesConstants.UserProfileImageUpdate, userId));
        }
    }
}
