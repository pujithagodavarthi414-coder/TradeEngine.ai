﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.W3rtSystem
{
    public class RoomTimeSlotOutputModel
    {
        public Guid? Id { get; set; }
        public Guid? RoomId { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public string DayOfWeek { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
    }
}
