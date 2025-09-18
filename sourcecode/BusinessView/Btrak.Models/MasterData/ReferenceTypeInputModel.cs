using System;
using System.ComponentModel.DataAnnotations;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class ReferenceTypeInputModel : InputModelBase
    {
        public ReferenceTypeInputModel() : base(InputTypeGuidConstants.ReferenceTypeInputCommandTypeGuid)
        {
        }
        
        public Guid? ReferenceTypeId { get; set; }
        [StringLength(50)]
        public string ReferenceTypeName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ReferenceTypeId = " + ReferenceTypeId);
            stringBuilder.Append(", ReferenceTypeName = " + ReferenceTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}