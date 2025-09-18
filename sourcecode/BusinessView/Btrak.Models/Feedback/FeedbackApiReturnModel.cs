using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Feedback
{
    public class FeedbackApiReturnModel
    {
        public Guid? FeedbackId { get; set; }
        public string Description { get; set; }
        public Guid? SenderUserId { get; set; }
        public string FullName { get; set; }
        public string ProfileImage { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int TotalCount { get; set; }
        public string CompanyName { get; set; }
        public string UserName { get; set; }
        public string MobileNo { get; set; }
    }
}
