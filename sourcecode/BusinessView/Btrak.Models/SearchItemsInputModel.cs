using System;

namespace Btrak.Models
{
    public class SearchItemsInputModel
    {
        public Guid? ItemId { get; set; }
        public string SearchText { get; set;}
        public string SearchUniqueId { get; set; }
    }
}
