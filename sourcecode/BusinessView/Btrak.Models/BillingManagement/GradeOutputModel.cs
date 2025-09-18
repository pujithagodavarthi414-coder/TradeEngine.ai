using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class GradeOutputModel
    {
        public Guid GradeId { get; set; }
        public Guid ProductId { get; set; }
        public string GradeName { get; set; }
        public string ProductName { get; set; }
        public string GstCode { get; set; }
        public DateTime InActiveDateTime { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
