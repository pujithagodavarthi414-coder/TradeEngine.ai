using System;

namespace Btrak.Models.Chat
{
    public class UserChatModel
    {
        public System.Guid Id { get; set; }
        public System.Guid? CompanyId { get; set; }
        public string SurName { get; set; }
        public string FirstName { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public System.Guid? RoleId { get; set; }
        public Nullable<bool> IsPasswordForceReset { get; set; }
        public bool IsActive { get; set; }
        public Nullable<System.Guid> TimeZoneId { get; set; }
        public string MobileNo { get; set; }
        public Nullable<bool> IsAdmin { get; set; }
        public bool IsActiveOnMobile { get; set; }
        public string ProfileImage { get; set; }
        public System.DateTime? RegisteredDateTime { get; set; }
        public DateTime? LastConnection { get; set; }
        public System.DateTime? CreatedDateTime { get; set; }
        public System.Guid? CreatedByUserId { get; set; }
        public Nullable<System.DateTime> UpdatedDateTime { get; set; }
        public Nullable<System.Guid> UpdatedByUserId { get; set; }
        public Guid? ChannelId { get; set; }
    }
}