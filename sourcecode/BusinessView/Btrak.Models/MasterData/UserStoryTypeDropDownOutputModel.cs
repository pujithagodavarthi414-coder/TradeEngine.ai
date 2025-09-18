using System;

namespace Btrak.Models.MasterData
{
    public class UserStoryTypeDropDownOutputModel
    {
        public Guid? UserStoryTypeId { get; set; }	
        public Guid? CompanyId { get; set; }
        public string UserStoryTypeName { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
       
        public int? VersionNumber { get; set; }
        public string ShortName { get; set; }
        public bool? IsBug { get; set; }
        public bool? IsUserStory { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsQaRequired { get; set; }
        public bool? IsLogTimeRequired { get; set; }

    }
}
