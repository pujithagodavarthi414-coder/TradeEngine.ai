using System;
using System.Text;

namespace Btrak.Models.Chat
{
    public class ChannelMemberApiReturnModel
    {
        public Guid? Id { get; set; }
        public Guid? CompanyId { get; set; }
        public string SurName { get; set; }
        public string FirstName { get; set; }
        public string UserName { get; set; }
        public string MobileNo { get; set; }
        public bool? IsAdmin { get; set; }
        public string ProfileImage { get; set; }
        public DateTime? RegisteredDateTime { get; set; }
        public DateTime? LastConnection { get; set; }
        public string RoleName { get; set; }
        public string Password { get; set; }
        public Guid? TimeZoneId { get; set; }
        public bool IsActiveOnMobile { get; set; }
        public bool? IsPasswordForceReset { get; set; }
        public bool IsActive { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public string CreatedOn { get; set; }

        public Guid? CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }

        public Guid? ChannelId { get; set; }

        public Guid? ChannelMemberId { get; set; }

        public byte[] TimeStamp { get; set; }

        public Guid? UserId { get; set; }

        public string ChannelName { get; set; }

        public string DesignationName { get; set; }

        public string UserStoryName { get; set; }

        public bool IsReadOnly { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", MobileNo = " + MobileNo);
            stringBuilder.Append(", IsAdmin = " + IsAdmin);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", RegisteredDateTime = " + RegisteredDateTime);
            stringBuilder.Append(", LastConnection = " + LastConnection);
            stringBuilder.Append(", ChannelId = " + ChannelId);

            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", Password = " + Password);
            stringBuilder.Append(", TimeZoneId = " + TimeZoneId);
            stringBuilder.Append(", IsActiveOnMobile = " + IsActiveOnMobile);
            stringBuilder.Append(", IsPasswordForceReset = " + IsPasswordForceReset);
            stringBuilder.Append(", IsActive = " + IsActive);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", ChannelName = "+ ChannelName);
            stringBuilder.Append(", IsReadOnly = " + IsReadOnly);

            return stringBuilder.ToString();
        }
    }
}
