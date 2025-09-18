using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Feedback
{
    public class FeedbackSubmitModel
    {
        public Guid? FeedbackId { get; set; }
        public string Description { get; set; }
    }
}
