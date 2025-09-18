using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BTrak.Common;

namespace Btrak.Models.GenericForm
{
    public class GenericFormKeySearchInputModel : SearchCriteriaInputModelBase
    {
        public GenericFormKeySearchInputModel() : base(InputTypeGuidConstants.GenericFormSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? GenericFormId { get; set; }
        public Guid? GenericId { get; set; }
        public string Key { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", GenericFormId = " + GenericFormId);
            stringBuilder.Append(", GenericId = " + GenericId);
            stringBuilder.Append(", Key = " + Key);
            return stringBuilder.ToString();
        }
    }
}
