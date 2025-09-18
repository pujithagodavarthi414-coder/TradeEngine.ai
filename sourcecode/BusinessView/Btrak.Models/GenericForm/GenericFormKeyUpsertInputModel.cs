using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.GenericForm
{
    public class GenericFormKeyUpsertInputModel : InputModelBase
    {
        public GenericFormKeyUpsertInputModel() : base(InputTypeGuidConstants.GenericFormKeyUpsertInputCommandTypeGuid)
        {
        }
        
        public Guid? GenericFormKeyId { get; set; }
        public Guid? GenericFormId { get; set; }
        public string Key { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GenericFormKeyId = " + GenericFormKeyId);
            stringBuilder.Append(", GenericFormId = " + GenericFormId);
            stringBuilder.Append(", Key = " + Key);
            stringBuilder.Append(", IsDefault = " + IsDefault);
            return stringBuilder.ToString();
        }
    }
}
