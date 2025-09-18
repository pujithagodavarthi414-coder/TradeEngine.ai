using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.CustomFields
{
    public class ResidentObservationApiReturnModel
    {
        public string FormName { get; set; }
        public string FormJson { get; set; }
        public string FormKeys { get; set; }
        public string FormDataJson { get; set; }
        public string ProfileImage { get; set; }
        public Guid? SubmittedByUserId { get; set; }
        public string SubmittedByUser { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public string ObservationName { get; set; }
    }
}
