using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class GetAllNationalitiesOutputModel
    {
        public Guid? NationalityId { get; set; }
        public string Nationality { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" NationalityId = " + NationalityId);
            stringBuilder.Append(", Nationality = " + Nationality);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
