using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class GetCustomApplicationTagInpuModel : InputModelBase
    {
        public GetCustomApplicationTagInpuModel() : base(InputTypeGuidConstants.GenericFormSubmittedUpsertInputModel)
        {
        }

        public Guid? CustomApplicationTagId { get; set; }
        public string SearchTagText { get; set; }
        public string GenericFormLabel { get; set; }
        public Guid? GenericFormKeyId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CustomApplicationTagId = " + CustomApplicationTagId);
            stringBuilder.Append(", SearchTagText = " + SearchTagText);
            stringBuilder.Append(", GenericFormKeyId = " + GenericFormKeyId);
            return stringBuilder.ToString();
        }
    }
}
