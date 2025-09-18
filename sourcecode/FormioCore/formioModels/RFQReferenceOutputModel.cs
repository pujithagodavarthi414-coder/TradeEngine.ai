using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels
{
    public class RFQReferenceOutputModel
    {
        public Guid? Id { get; set; }
        public Guid? ReferenceId { get; set; }
        public bool? IsBroker { get; set; }
        public int? RFQId { get; set; }
        public string RFQUniqueId { get; set; }
    }
}
