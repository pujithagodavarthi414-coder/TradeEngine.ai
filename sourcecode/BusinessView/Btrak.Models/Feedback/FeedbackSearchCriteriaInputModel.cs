using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Feedback
{
   public  class FeedbackSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public FeedbackSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetFeedbacks)
        {
           
        }
        public Guid? FeedbackId { get; set; }
        public string Description { get; set; }
        
    }
}
