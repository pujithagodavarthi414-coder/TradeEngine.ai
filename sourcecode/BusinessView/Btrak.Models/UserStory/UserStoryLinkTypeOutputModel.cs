using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
    public class UserStoryLinkTypeOutputModel
    {
        public Guid? LinkUserStoryTypeId { get; set; }
        public string LinkUserStoryTypeName { get; set; }
        public DateTime? CreatedDateTime { get; set; }
    }
}
