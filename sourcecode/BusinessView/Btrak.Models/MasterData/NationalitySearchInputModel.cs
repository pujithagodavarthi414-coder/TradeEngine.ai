using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class NationalitySearchInputModel : InputModelBase
    {
        public NationalitySearchInputModel() : base(InputTypeGuidConstants.NationalitySearchInputCommandTypeGuid)
        {
        }

        public Guid? NationalityId { get; set; }
        public string SearchText { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("NationalityId = " + NationalityId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
