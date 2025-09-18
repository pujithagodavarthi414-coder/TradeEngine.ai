using System.Collections.Generic;

namespace BTrak.Common
{
    public class ListItems
    {
        public List<ListItem> ListRecords { get; set; } = new List<ListItem>();
    }

    public  class MACAddressListItems
    {
        public List<MACAddressListItem> ListRecords { get; set; } = new List<MACAddressListItem>();
    }
}
