using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class GradeInputModel
    {
        public Guid? GradeId { get; set; }
        public Guid? ProductId { get; set; }
        public string GradeName { get; set; }
        public string GstCode { get; set; }
        public int GradeOrder { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", GradeId = " + GradeId);
            stringBuilder.Append(", ProductId = " + ProductId);
            stringBuilder.Append(", GstCode = " + GstCode);
            stringBuilder.Append(", GradeName = " + GradeName);
            stringBuilder.Append(", GradeOrder = " + GradeOrder);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
