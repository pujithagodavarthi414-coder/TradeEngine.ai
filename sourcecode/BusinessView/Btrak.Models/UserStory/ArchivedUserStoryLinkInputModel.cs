using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
   public  class ArchivedUserStoryLinkInputModel
    {
        public Guid? UserStoryLinkId { get; set; }
        public Guid? UserStoryId { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public string TimeZone { get; set; }
    }
}
