using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Models.Widgets
{
    public class CustomAppChartModel : InputModelBase
    {
        public CustomAppChartModel() : base(InputTypeGuidConstants.CustomWidgetUpsertInputCommandTypeGuid)
        {
        }

        public string VisualizationName { get; set; }

        public string PersistanceJson { get; set; }

        public string PivotMeasurersToDisplay { get; set; }

        public string HeatMapMeasure { get; set; }

        public string XCoOrdinate { get; set; }

        public string[] YCoOrdinate { get; set; }

        public string YAxisDetails { get; set; }

        public string VisualizationType { get; set; }

        public string FilterQuery { get; set; }

        public string ColumnFormatQuery { get; set; }
        public string ColumnAltName { get; set; }
        public List<CustomWidgetHeaderModel> DefaultColumns { get; set; }

        public string DefaultColumnsXml { get; set; }

        public bool? IsDefault { get; set; }

        public Guid? CustomApplicationChartId { get; set; }
        public string HeaderBackgroundColor { get; set; }
        public string HeaderFontColor { get; set; }
        public string ColumnBackgroundColor { get; set; }
        public string ColumnFontFamily { get; set; }
        public string ColumnFontColor { get; set; }
        public string RowBackgroundColor { get; set; }
        public string ChartColorJson { get; set; }
        public List<VisualisationColorModel> VisualisationColors { get; set; }
    }

    public class VisualisationColorModel
    {
        public string YAxisColumnName { get; set; }
        public string SelectedColor { get; set; } 
    }
}
