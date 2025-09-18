using BTrak.Common;
using System;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class NationalityUpsertModel : InputModelBase
    {
        public NationalityUpsertModel() : base(InputTypeGuidConstants.GenericFormInputCommandTypeGuid)
        {
        }

        public Guid? NationalityId { get; set; }
        [StringLength(50)]
        public string NationalityName { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" NationalityId = " + NationalityId);
            stringBuilder.Append(", NationalityName = " + NationalityName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}