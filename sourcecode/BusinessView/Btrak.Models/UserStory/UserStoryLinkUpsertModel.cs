using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
   public  class UserStoryLinkUpsertModel
    {
        public Guid? UserStoryId { get; set; }
        public Guid? LinkUserStoryTypeId { get; set; }
        public Guid? UserStoryLinkId { get; set; }
        public Guid? LinkUserStoryId { get; set; }
        public bool? IsSprintUserStories { get; set; }
        public string TimeZone { get; set; }
    }
}
