using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class GenericFormTypeUpsertModel: InputModelBase 
    {
        
        public GenericFormTypeUpsertModel() : base(InputTypeGuidConstants.GenericFormInputCommandTypeGuid)
        {
        }
        public Guid? FormTypeId { get; set; }
        public string FormTypeName { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FormTypeId= " + FormTypeId);
            stringBuilder.Append(", FormTypeName= " + FormTypeName);
            stringBuilder.Append(", IsArchived= " + IsArchived);
            return stringBuilder.ToString();
        }   
    }
}
