using System;

namespace Btrak.Models.Chat
{
    public class RecentConversationsSpReturnModel
    {
        public Guid? RecentMessageId { get; set; }
        public Guid? SenderId { get; set; }
        public string SenderFirstName { get; set; }
        public string SenderSurName { get; set; }
        public string SenderProfile { get; set; }
        public Guid? ReceiverId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string FullName { get; set; }
        public bool IsActive { get; set; }
        public Guid? TimeZoneId { get; set; }
        public string MobileNo { get; set; }
        public bool IsAdmin { get; set; }
        public bool IsActiveOnMobile { get; set; }
        public DateTime? RegisteredDateTime { get; set; }
        public DateTime? LastConnection { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public string DesignationName { get; set; }
        public string DepartmentName { get; set; }
        public string Profile { get; set; }
        public DateTime? RecentMessageDateTime { get; set; }
        public bool IsMuted { get; set; }
        public bool IsStarred { get; set; }
        public bool IsLeave { get; set; }
        public bool IsOnLeave { get; set; }
        public Guid? StatusId { get; set; }
        public bool IsClient { get; set; }
        public string ClientCompanyName { get; set; }
        public bool IsExternal { get; set; }
    }
}