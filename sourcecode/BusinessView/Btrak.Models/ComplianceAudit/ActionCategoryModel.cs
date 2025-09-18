using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
   public  class ActionCategoryModel
    {
        public Guid? ActionCategoryId { get; set; }
        public String ActionCategoryName { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ActionCategoryId = " + ActionCategoryId);
            stringBuilder.Append("ActionCategoryName = " + ActionCategoryName);
            stringBuilder.Append("IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}




