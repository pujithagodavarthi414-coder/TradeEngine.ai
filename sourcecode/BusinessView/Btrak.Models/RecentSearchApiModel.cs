
using System;

namespace Btrak.Models
{
    public class RecentSearchApiModel
    {
        public string Name { get; set; }
        public int recentSearchType { get; set; }
        public Guid? ItemId { get; set; }
    }
}
