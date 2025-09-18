using System;

namespace Btrak.Models.UserStory
{
    public class UserStoryAutoLogByTimeSheetModel
    {
        public Guid? UserStoryId { get; set; }
        public bool IsFromSprints { get; set; }
        public bool IsFromAdhoc { get; set;  }
    }
}
