using System;

namespace Btrak.Models.Chat
{
    public class RecentIndividualConversationSpReturnModel
    {
        public Guid? Id { get; set; }
        public string Name { get; set; }
        public string ProfileImage { get; set; }
        public int UnreadMessageCount { get; set; }
        public bool IsMuted { get; set; }
        public bool IsStarred { get; set; }
        public bool IsLeave { get; set; }
        public Guid? StatusId { get; set; }
        public bool IsOnLeave { get; set; }
        public bool IsClient { get; set; }
        public string ClientCompanyName { get; set; }
        public string DesignationName { get; set; }
        public string DepartmentName { get; set; }
        public bool IsExternal { get; set; }
    }
}
