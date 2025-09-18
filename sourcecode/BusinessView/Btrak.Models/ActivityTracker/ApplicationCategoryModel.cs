using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class ApplicationCategoryModel
    {
        public Guid? ApplicationCategoryId { get; set; }
        public string ApplicationCategoryName { get; set; }
        public Guid CompanyId { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool IsArchived { get; set; }
    }
}
