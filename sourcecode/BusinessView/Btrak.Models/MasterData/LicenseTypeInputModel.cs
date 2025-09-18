using System;
using System.ComponentModel.DataAnnotations;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class LicenseTypeInputModel : InputModelBase
    {
        public LicenseTypeInputModel() : base(InputTypeGuidConstants.LicenceTypeInputCommandTypeGuid)
        {
        }
       
        public Guid? LicenceTypeId { get; set; }
        [StringLength(50)]
        public string LicenceTypeName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("LicenseTypeId = " + LicenceTypeId);
            stringBuilder.Append(", LicenseTypeName = " + LicenceTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}