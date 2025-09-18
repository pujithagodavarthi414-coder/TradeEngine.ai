using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class GendersOutputModel
    {
        public Guid? GenderId { get; set; }
        public string Gender { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" GenderId = " + GenderId);
            stringBuilder.Append(", Gender = " + Gender);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
