using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.W3rtSystem
{
    public class RoomSearchOutputModel
    {
        public string RoomName { get; set; }

        public string RoomAddress { get; set; }

        public decimal RoomPrice { get; set; }

        public decimal RoomTax { get; set; }

        public string RoomDescription { get; set; }

        public Guid? RoomId { get; set; }

        public decimal MaxPrice { get; set; }

        public decimal MinPrice { get; set; }

        public string ImageJson { get; set; }

        public string Town { get; set; }

        public string EventTypeName { get; set; }

        public string Locality { get; set; }

        public Guid? OrganisationId { get; set; }

        public string VenueName { get; set; }

        public string Description { get; set; }

        public string Video { get; set; }

        public string OrganisationName { get; set; }

        public int IsArchived { get; set; }
    }
}
