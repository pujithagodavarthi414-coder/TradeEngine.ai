using System;
using static BTrak.Common.Enumerators;

namespace Btrak.Models
{
    public class SearchItemsOutputModel
    {
        public string ItemName { get; set; }
        public string ItemUniqueName { get; set; }
        public TaskType ItemType { get; set; }
        public Guid? ItemId { get; set; }
    }
}
