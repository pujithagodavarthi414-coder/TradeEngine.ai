using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class ChannelsListEntity
    {
        public Guid ChannelId { get; set; }

        public Guid CompanyId { get; set; }

        public string ChannelName { get; set; }

        public Guid MemberUserId { get; set; }

        public string EmployeeName { get; set; }
        
        public Guid ChannelMemberId { get; set; }

        public Guid Id { get; set; }
        public string SurName { get; set; }
        public string FirstName { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public Guid RoleId { get; set; }
        public bool? IsPasswordForceReset { get; set; }
        public bool IsActive { get; set; }
        public Guid? TimeZoneId { get; set; }
        public string MobileNo { get; set; }
        public bool? IsAdmin { get; set; }
        public bool IsActiveOnMobile { get; set; }
        public string ProfileImage { get; set; }
        public DateTime RegisteredDateTime { get; set; }
        public DateTime? LastConnection { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public bool IsActiveMember { get; set; }
        public bool? IsDeleted { get; set; }
        public Guid UserId { get; set; }
        public int MessagesUnReadCount { get; set; }
    }
}
