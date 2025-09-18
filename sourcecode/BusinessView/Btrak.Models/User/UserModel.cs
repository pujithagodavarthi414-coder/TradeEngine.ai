using System;

namespace Btrak.Models.User
{
    public class UserModel
    {
		public Guid? Id { get; set; }
		public Guid? UserId { get; set; }
        public Guid? CompanyId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public Guid? RoleId { get; set; }
        public bool IsPasswordForceReset { get; set; }
        public bool IsActive { get; set; }
        public Guid? TimeZoneId { get; set; }
        public string MobileNo { get; set; }
        public bool IsAdmin { get; set; }
        public bool IsActiveOnMobile { get; set; }
        public string ProfileImage { get; set; }
        public DateTime? LastConnection { get; set; }
        public DateTime? RegisteredDateTime { get; set; }
        public Guid? OperationsPerformedBy { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public int PageNo { get; set; } = 1;
        public int PageSize { get; set; } = 10;
        public string FullName { get; set; }
		public string RoleName { get; set; }
        public string DesignationName { get; set; }
        public string DepartmentName { get; set; }
        public int TotalCount { get; set; }
        public bool IsMuted { get; set; }
        public bool IsStarred { get; set; }
        public bool IsLeave { get; set; }
        public int MessagesUnReadCount { get; set; }
        public Guid ChannelId { get; set; }
        public string UserName { get; set; }
        public Guid BranchId { get; set; }

        public bool IsAddedToChannel { get; set; }

        public bool IsOnLeave { get; set; }
        public Guid? StatusId { get; set; }

        public int PinnedMessageCount { get; set; }
        public int StarredMessageCount { get; set; }
        public bool IsClient { get; set; }
        public string ClientCompanyName { get; set; }
        public bool IsExternal { get; set; }
    }
}
