using Btrak.Models.GenericForm;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
    public class UserStoryCustomFieldsModel
    {
        public Guid? CustomFieldId { get; set; }
        public string FormDataJson { get; set; }
        public string FormKeys { get; set; }
        public DateTime? CreatedDateTime { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CustomFieldId = " + CustomFieldId);
            stringBuilder.Append("FormDataJson = " + FormDataJson);
            stringBuilder.Append("FormKeys = " + FormKeys);
            stringBuilder.Append("CreatedDateTime = " + CreatedDateTime);
            return stringBuilder.ToString();
        }
    }
}
