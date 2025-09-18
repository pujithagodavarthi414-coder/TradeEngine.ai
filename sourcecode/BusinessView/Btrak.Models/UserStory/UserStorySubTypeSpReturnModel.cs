using System;

namespace Btrak.Models.UserStory
{
    public class UserStorySubTypeSpReturnModel
    {
        public Guid UserStorySubTypeId { get; set; }
        public string UserStorySubTypeName { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public DateTimeOffset? InActiveDateTime { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? VersionNumber { get; set; }
        public Guid? OriginalId { get; set; }
    }
}
