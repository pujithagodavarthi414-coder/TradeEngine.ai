using System;
using System.Text;
using static BTrak.Common.Enumerators;

namespace Btrak.Models.RecentSearch
{
    public class RecentSearchModel
    {
        public string RecentSearch { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? ItemId { get; set; }
        public RecentSearchType RecentSearchType { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RecentSearch = " + RecentSearch);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            return stringBuilder.ToString();
        }
    }
}
