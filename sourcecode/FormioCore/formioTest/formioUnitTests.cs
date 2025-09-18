using AutoFixture;
using formioModels;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using formioModels.Data;
using formioRepo.DataSource;
using formioRepo.DataSet;
using formioServices.Data;
using Newtonsoft.Json;

namespace formioTest
{
    [TestFixture]
    public class DataSourceUnitTests
    {
        private readonly Fixture _fixture = new Fixture();
        [Test]
        public void CreateDataSource_Successfully_ShouldReturnId()
        {
            // Arrange
            DataSourceInputModel dataSourceUpsertInputModel = this.GetDataSource();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            //IDataSourceService dataSource = this.GetInstance();
            // Act

            //var result = dataSource.CreateDataSource(dataSourceUpsertInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
           // Assert.AreEqual(new Guid("3B3DE008-7F82-4ADF-A867-8827A99CE596"), new Guid(result.ToString()));
        }
        [Test]
        public void UpdateDataSource_Successfully_ShouldReturnId()
        {
            // Arrange
            DataSourceInputModel dataSourceInputModel = this.GetDataSource();
            dataSourceInputModel.Id = new Guid("3B3DE008-7F82-4ADF-A867-8827A99CE596");
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            //IDataSourceService dataSource = this.GetInstance();
            // Act

           // var result = dataSource.UpdateDataSource(dataSourceInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
           // Assert.AreEqual(new Guid("3B3DE008-7F82-4ADF-A867-8827A99CE596"), new Guid(result.ToString()));
        }
        [TestCase(null, null, null, null, "5D893EB5-CDE3-45E0-9290-2382220CB704")]
        [TestCase("", "", null, "", "5D893EB5-CDE3-45E0-9290-2382220CB704")]
        [TestCase(null, "{\"components\":[{\"label\":\"Text Field\",\"showWordCount\":false,\"showCharCount\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"textfield\",\"input\":true,\"key\":\"textField2\",\"defaultValue\":\"\",\"validate\":{\"customMessage\":\"\",\"json\":\"\"},\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"widget\":{\"type\":\"\"},\"reorder\":false,\"inputFormat\":\"plain\",\"encrypted\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}},{\"label\":\"Columns\",\"columns\":[{\"components\":[{\"mask\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"table\",\"input\":false,\"key\":\"table2\",\"label\":\"\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"rows\":[[{\"components\":[{\"label\":\"Tabs\",\"components\":[{\"label\":\"Tab 1\",\"key\":\"tab1\",\"components\":[{\"label\":\"Text Field\",\"showWordCount\":false,\"showCharCount\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"textfield\",\"input\":true,\"key\":\"textField3\",\"defaultValue\":\"\",\"validate\":{\"customMessage\":\"\",\"json\":\"\",\"required\":false,\"custom\":\"\",\"customPrivate\":false,\"minLength\":\"\",\"maxLength\":\"\",\"minWords\":\"\",\"maxWords\":\"\",\"pattern\":\"\"},\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\",\"eq\":\"\"},\"tab\":0,\"widget\":{\"type\":\"\",\"format\":\"yyyy-MM-dd hh:mm a\",\"dateFormat\":\"yyyy-MM-dd hh:mm a\",\"saveAs\":\"text\"},\"reorder\":false,\"inputFormat\":\"plain\",\"encrypted\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{},\"placeholder\":\"\",\"prefix\":\"\",\"customClass\":\"\",\"suffix\":\"\",\"multiple\":false,\"protected\":false,\"unique\":false,\"persistent\":true,\"hidden\":false,\"clearOnHide\":true,\"dataGridLabel\":false,\"labelPosition\":\"top\",\"labelWidth\":30,\"labelMargin\":3,\"description\":\"\",\"errorLabel\":\"\",\"tooltip\":\"\",\"hideLabel\":false,\"tabindex\":\"\",\"disabled\":false,\"autofocus\":false,\"dbIndex\":false,\"customDefaultValue\":\"\",\"calculateValue\":\"\",\"allowCalculateOverride\":false,\"refreshOn\":\"\",\"clearOnRefresh\":false,\"validateOn\":\"change\",\"mask\":false,\"inputType\":\"text\",\"inputMask\":\"\",\"id\":\"e8jcsd7\"}]},{\"label\":\"tab2\",\"key\":\"tab2\"}],\"mask\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"tabs\",\"input\":false,\"key\":\"tabs\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}}]},{\"components\":[]},{\"components\":[]}],[{\"components\":[]},{\"components\":[]},{\"components\":[]}],[{\"components\":[]},{\"components\":[]},{\"components\":[]}]],\"header\":[],\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}}],\"width\":6,\"offset\":0,\"push\":0,\"pull\":0,\"type\":\"column\",\"input\":false,\"hideOnChildrenHidden\":false,\"key\":\"column\",\"tableView\":true,\"label\":\"Column\"},{\"components\":[],\"width\":6,\"offset\":0,\"push\":0,\"pull\":0,\"type\":\"column\",\"input\":false,\"hideOnChildrenHidden\":false,\"key\":\"column\",\"tableView\":true,\"label\":\"Column\"}],\"mask\":false,\"tableView\":false,\"alwaysEnabled\":false,\"type\":\"columns\",\"input\":false,\"key\":\"columns2\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}},{\"type\":\"button\",\"label\":\"Submit\",\"key\":\"submit\",\"disableOnInvalid\":true,\"theme\":\"primary\",\"input\":true,\"tableView\":true}]}", null, "form", "empty")]
        [TestCase("testForm11testForm11testForm11testForm11testForm11testForm11testForm11testForm11testForm11testForm11testForm11", null, null, "form", "empty")]
        [TestCase("testForm", "{\"components\":[{\"label\":\"Text Field\",\"showWordCount\":false,\"showCharCount\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"textfield\",\"input\":true,\"key\":\"textField2\",\"defaultValue\":\"\",\"validate\":{\"customMessage\":\"\",\"json\":\"\"},\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"widget\":{\"type\":\"\"},\"reorder\":false,\"inputFormat\":\"plain\",\"encrypted\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}},{\"label\":\"Columns\",\"columns\":[{\"components\":[{\"mask\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"table\",\"input\":false,\"key\":\"table2\",\"label\":\"\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"rows\":[[{\"components\":[{\"label\":\"Tabs\",\"components\":[{\"label\":\"Tab 1\",\"key\":\"tab1\",\"components\":[{\"label\":\"Text Field\",\"showWordCount\":false,\"showCharCount\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"textfield\",\"input\":true,\"key\":\"textField3\",\"defaultValue\":\"\",\"validate\":{\"customMessage\":\"\",\"json\":\"\",\"required\":false,\"custom\":\"\",\"customPrivate\":false,\"minLength\":\"\",\"maxLength\":\"\",\"minWords\":\"\",\"maxWords\":\"\",\"pattern\":\"\"},\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\",\"eq\":\"\"},\"tab\":0,\"widget\":{\"type\":\"\",\"format\":\"yyyy-MM-dd hh:mm a\",\"dateFormat\":\"yyyy-MM-dd hh:mm a\",\"saveAs\":\"text\"},\"reorder\":false,\"inputFormat\":\"plain\",\"encrypted\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{},\"placeholder\":\"\",\"prefix\":\"\",\"customClass\":\"\",\"suffix\":\"\",\"multiple\":false,\"protected\":false,\"unique\":false,\"persistent\":true,\"hidden\":false,\"clearOnHide\":true,\"dataGridLabel\":false,\"labelPosition\":\"top\",\"labelWidth\":30,\"labelMargin\":3,\"description\":\"\",\"errorLabel\":\"\",\"tooltip\":\"\",\"hideLabel\":false,\"tabindex\":\"\",\"disabled\":false,\"autofocus\":false,\"dbIndex\":false,\"customDefaultValue\":\"\",\"calculateValue\":\"\",\"allowCalculateOverride\":false,\"refreshOn\":\"\",\"clearOnRefresh\":false,\"validateOn\":\"change\",\"mask\":false,\"inputType\":\"text\",\"inputMask\":\"\",\"id\":\"e8jcsd7\"}]},{\"label\":\"tab2\",\"key\":\"tab2\"}],\"mask\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"tabs\",\"input\":false,\"key\":\"tabs\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}}]},{\"components\":[]},{\"components\":[]}],[{\"components\":[]},{\"components\":[]},{\"components\":[]}],[{\"components\":[]},{\"components\":[]},{\"components\":[]}]],\"header\":[],\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}}],\"width\":6,\"offset\":0,\"push\":0,\"pull\":0,\"type\":\"column\",\"input\":false,\"hideOnChildrenHidden\":false,\"key\":\"column\",\"tableView\":true,\"label\":\"Column\"},{\"components\":[],\"width\":6,\"offset\":0,\"push\":0,\"pull\":0,\"type\":\"column\",\"input\":false,\"hideOnChildrenHidden\":false,\"key\":\"column\",\"tableView\":true,\"label\":\"Column\"}],\"mask\":false,\"tableView\":false,\"alwaysEnabled\":false,\"type\":\"columns\",\"input\":false,\"key\":\"columns2\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}},{\"type\":\"button\",\"label\":\"Submit\",\"key\":\"submit\",\"disableOnInvalid\":true,\"theme\":\"primary\",\"input\":true,\"tableView\":true}]}", null, "form", null)]
        public void CreateDataSource_UnSuccessfully_ShouldReturnException(string name,
            string fields, string id, string dataSourceType, string key)
        {
            // Arrange
            DataSourceInputModel dataSourceInputModel = this.GetDataSource();
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            //IDataSourceService dataSource = this.GetInstance();
            dataSourceInputModel.Id = id != null ? new Guid("5D893EB5-CDE3-45E0-9290-2382220CB704") : null;
            dataSourceInputModel.Name = name;
            dataSourceInputModel.DataSourceType = dataSourceType;
            //dataSourceInputModel.Fields = fields;
            var validationMessages = new List<ValidationMessage>();
            // Act
          //  dataSource.CreateDataSource(dataSourceInputModel, loggedInContext, validationMessages);
            // Assert
            Assert.AreEqual(false, validationMessages.Count == 0);
        }
        [TestCase(null, null, null,null, "5D893EB5-CDE3-45E0-9290-2382220CB704")]
        [TestCase("", "", null,"", "5D893EB5-CDE3-45E0-9290-2382220CB704")]
        [TestCase(null, "{\"components\":[{\"label\":\"Text Field\",\"showWordCount\":false,\"showCharCount\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"textfield\",\"input\":true,\"key\":\"textField2\",\"defaultValue\":\"\",\"validate\":{\"customMessage\":\"\",\"json\":\"\"},\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"widget\":{\"type\":\"\"},\"reorder\":false,\"inputFormat\":\"plain\",\"encrypted\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}},{\"label\":\"Columns\",\"columns\":[{\"components\":[{\"mask\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"table\",\"input\":false,\"key\":\"table2\",\"label\":\"\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"rows\":[[{\"components\":[{\"label\":\"Tabs\",\"components\":[{\"label\":\"Tab 1\",\"key\":\"tab1\",\"components\":[{\"label\":\"Text Field\",\"showWordCount\":false,\"showCharCount\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"textfield\",\"input\":true,\"key\":\"textField3\",\"defaultValue\":\"\",\"validate\":{\"customMessage\":\"\",\"json\":\"\",\"required\":false,\"custom\":\"\",\"customPrivate\":false,\"minLength\":\"\",\"maxLength\":\"\",\"minWords\":\"\",\"maxWords\":\"\",\"pattern\":\"\"},\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\",\"eq\":\"\"},\"tab\":0,\"widget\":{\"type\":\"\",\"format\":\"yyyy-MM-dd hh:mm a\",\"dateFormat\":\"yyyy-MM-dd hh:mm a\",\"saveAs\":\"text\"},\"reorder\":false,\"inputFormat\":\"plain\",\"encrypted\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{},\"placeholder\":\"\",\"prefix\":\"\",\"customClass\":\"\",\"suffix\":\"\",\"multiple\":false,\"protected\":false,\"unique\":false,\"persistent\":true,\"hidden\":false,\"clearOnHide\":true,\"dataGridLabel\":false,\"labelPosition\":\"top\",\"labelWidth\":30,\"labelMargin\":3,\"description\":\"\",\"errorLabel\":\"\",\"tooltip\":\"\",\"hideLabel\":false,\"tabindex\":\"\",\"disabled\":false,\"autofocus\":false,\"dbIndex\":false,\"customDefaultValue\":\"\",\"calculateValue\":\"\",\"allowCalculateOverride\":false,\"refreshOn\":\"\",\"clearOnRefresh\":false,\"validateOn\":\"change\",\"mask\":false,\"inputType\":\"text\",\"inputMask\":\"\",\"id\":\"e8jcsd7\"}]},{\"label\":\"tab2\",\"key\":\"tab2\"}],\"mask\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"tabs\",\"input\":false,\"key\":\"tabs\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}}]},{\"components\":[]},{\"components\":[]}],[{\"components\":[]},{\"components\":[]},{\"components\":[]}],[{\"components\":[]},{\"components\":[]},{\"components\":[]}]],\"header\":[],\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}}],\"width\":6,\"offset\":0,\"push\":0,\"pull\":0,\"type\":\"column\",\"input\":false,\"hideOnChildrenHidden\":false,\"key\":\"column\",\"tableView\":true,\"label\":\"Column\"},{\"components\":[],\"width\":6,\"offset\":0,\"push\":0,\"pull\":0,\"type\":\"column\",\"input\":false,\"hideOnChildrenHidden\":false,\"key\":\"column\",\"tableView\":true,\"label\":\"Column\"}],\"mask\":false,\"tableView\":false,\"alwaysEnabled\":false,\"type\":\"columns\",\"input\":false,\"key\":\"columns2\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}},{\"type\":\"button\",\"label\":\"Submit\",\"key\":\"submit\",\"disableOnInvalid\":true,\"theme\":\"primary\",\"input\":true,\"tableView\":true}]}", null,"form","empty")]
        [TestCase("testForm11testForm11testForm11testForm11testForm11testForm11testForm11testForm11testForm11testForm11testForm11", null, null,"form","empty")]
        [TestCase("testForm", "{\"components\":[{\"label\":\"Text Field\",\"showWordCount\":false,\"showCharCount\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"textfield\",\"input\":true,\"key\":\"textField2\",\"defaultValue\":\"\",\"validate\":{\"customMessage\":\"\",\"json\":\"\"},\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"widget\":{\"type\":\"\"},\"reorder\":false,\"inputFormat\":\"plain\",\"encrypted\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}},{\"label\":\"Columns\",\"columns\":[{\"components\":[{\"mask\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"table\",\"input\":false,\"key\":\"table2\",\"label\":\"\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"rows\":[[{\"components\":[{\"label\":\"Tabs\",\"components\":[{\"label\":\"Tab 1\",\"key\":\"tab1\",\"components\":[{\"label\":\"Text Field\",\"showWordCount\":false,\"showCharCount\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"textfield\",\"input\":true,\"key\":\"textField3\",\"defaultValue\":\"\",\"validate\":{\"customMessage\":\"\",\"json\":\"\",\"required\":false,\"custom\":\"\",\"customPrivate\":false,\"minLength\":\"\",\"maxLength\":\"\",\"minWords\":\"\",\"maxWords\":\"\",\"pattern\":\"\"},\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\",\"eq\":\"\"},\"tab\":0,\"widget\":{\"type\":\"\",\"format\":\"yyyy-MM-dd hh:mm a\",\"dateFormat\":\"yyyy-MM-dd hh:mm a\",\"saveAs\":\"text\"},\"reorder\":false,\"inputFormat\":\"plain\",\"encrypted\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{},\"placeholder\":\"\",\"prefix\":\"\",\"customClass\":\"\",\"suffix\":\"\",\"multiple\":false,\"protected\":false,\"unique\":false,\"persistent\":true,\"hidden\":false,\"clearOnHide\":true,\"dataGridLabel\":false,\"labelPosition\":\"top\",\"labelWidth\":30,\"labelMargin\":3,\"description\":\"\",\"errorLabel\":\"\",\"tooltip\":\"\",\"hideLabel\":false,\"tabindex\":\"\",\"disabled\":false,\"autofocus\":false,\"dbIndex\":false,\"customDefaultValue\":\"\",\"calculateValue\":\"\",\"allowCalculateOverride\":false,\"refreshOn\":\"\",\"clearOnRefresh\":false,\"validateOn\":\"change\",\"mask\":false,\"inputType\":\"text\",\"inputMask\":\"\",\"id\":\"e8jcsd7\"}]},{\"label\":\"tab2\",\"key\":\"tab2\"}],\"mask\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"tabs\",\"input\":false,\"key\":\"tabs\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}}]},{\"components\":[]},{\"components\":[]}],[{\"components\":[]},{\"components\":[]},{\"components\":[]}],[{\"components\":[]},{\"components\":[]},{\"components\":[]}]],\"header\":[],\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}}],\"width\":6,\"offset\":0,\"push\":0,\"pull\":0,\"type\":\"column\",\"input\":false,\"hideOnChildrenHidden\":false,\"key\":\"column\",\"tableView\":true,\"label\":\"Column\"},{\"components\":[],\"width\":6,\"offset\":0,\"push\":0,\"pull\":0,\"type\":\"column\",\"input\":false,\"hideOnChildrenHidden\":false,\"key\":\"column\",\"tableView\":true,\"label\":\"Column\"}],\"mask\":false,\"tableView\":false,\"alwaysEnabled\":false,\"type\":\"columns\",\"input\":false,\"key\":\"columns2\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}},{\"type\":\"button\",\"label\":\"Submit\",\"key\":\"submit\",\"disableOnInvalid\":true,\"theme\":\"primary\",\"input\":true,\"tableView\":true}]}", null,"form",null)]
        public void UpdateDataSource_UnSuccessfully_ShouldReturnException(string name,
            string fields, string id, string dataSourceType, string key)
        {
            // Arrange
            DataSourceInputModel dataSourceInputModel = this.GetDataSource();
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            //IDataSourceService dataSource = this.GetInstance();
            dataSourceInputModel.Id = id != null ? new Guid("5D893EB5-CDE3-45E0-9290-2382220CB704") : null;
            dataSourceInputModel.Name = name;
            dataSourceInputModel.DataSourceType = dataSourceType;
           // dataSourceInputModel.Fields = fields;
            var validationMessages = new List<ValidationMessage>();
            // Act
            //dataSource.UpdateDataSource(dataSourceInputModel, loggedInContext, validationMessages);
            // Assert
            Assert.AreEqual(false, validationMessages.Count == 0);
        }
        private DataSourceInputModel GetDataSource()
        {
            var result = this._fixture.Create<DataSourceInputModel>();
            result.Id = null;
            result.Name = "testForm";
            result.DataSourceType = "Form";
           // result.Fields = "{\"components\":[{\"label\":\"Text Field\",\"showWordCount\":false,\"showCharCount\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"textfield\",\"input\":true,\"key\":\"textField2\",\"defaultValue\":\"\",\"validate\":{\"customMessage\":\"\",\"json\":\"\"},\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"widget\":{\"type\":\"\"},\"reorder\":false,\"inputFormat\":\"plain\",\"encrypted\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}},{\"label\":\"Columns\",\"columns\":[{\"components\":[{\"mask\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"table\",\"input\":false,\"key\":\"table2\",\"label\":\"\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"rows\":[[{\"components\":[{\"label\":\"Tabs\",\"components\":[{\"label\":\"Tab 1\",\"key\":\"tab1\",\"components\":[{\"label\":\"Text Field\",\"showWordCount\":false,\"showCharCount\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"textfield\",\"input\":true,\"key\":\"textField3\",\"defaultValue\":\"\",\"validate\":{\"customMessage\":\"\",\"json\":\"\",\"required\":false,\"custom\":\"\",\"customPrivate\":false,\"minLength\":\"\",\"maxLength\":\"\",\"minWords\":\"\",\"maxWords\":\"\",\"pattern\":\"\"},\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\",\"eq\":\"\"},\"tab\":0,\"widget\":{\"type\":\"\",\"format\":\"yyyy-MM-dd hh:mm a\",\"dateFormat\":\"yyyy-MM-dd hh:mm a\",\"saveAs\":\"text\"},\"reorder\":false,\"inputFormat\":\"plain\",\"encrypted\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{},\"placeholder\":\"\",\"prefix\":\"\",\"customClass\":\"\",\"suffix\":\"\",\"multiple\":false,\"protected\":false,\"unique\":false,\"persistent\":true,\"hidden\":false,\"clearOnHide\":true,\"dataGridLabel\":false,\"labelPosition\":\"top\",\"labelWidth\":30,\"labelMargin\":3,\"description\":\"\",\"errorLabel\":\"\",\"tooltip\":\"\",\"hideLabel\":false,\"tabindex\":\"\",\"disabled\":false,\"autofocus\":false,\"dbIndex\":false,\"customDefaultValue\":\"\",\"calculateValue\":\"\",\"allowCalculateOverride\":false,\"refreshOn\":\"\",\"clearOnRefresh\":false,\"validateOn\":\"change\",\"mask\":false,\"inputType\":\"text\",\"inputMask\":\"\",\"id\":\"e8jcsd7\"}]},{\"label\":\"tab2\",\"key\":\"tab2\"}],\"mask\":false,\"tableView\":true,\"alwaysEnabled\":false,\"type\":\"tabs\",\"input\":false,\"key\":\"tabs\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}}]},{\"components\":[]},{\"components\":[]}],[{\"components\":[]},{\"components\":[]},{\"components\":[]}],[{\"components\":[]},{\"components\":[]},{\"components\":[]}]],\"header\":[],\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}}],\"width\":6,\"offset\":0,\"push\":0,\"pull\":0,\"type\":\"column\",\"input\":false,\"hideOnChildrenHidden\":false,\"key\":\"column\",\"tableView\":true,\"label\":\"Column\"},{\"components\":[],\"width\":6,\"offset\":0,\"push\":0,\"pull\":0,\"type\":\"column\",\"input\":false,\"hideOnChildrenHidden\":false,\"key\":\"column\",\"tableView\":true,\"label\":\"Column\"}],\"mask\":false,\"tableView\":false,\"alwaysEnabled\":false,\"type\":\"columns\",\"input\":false,\"key\":\"columns2\",\"conditional\":{\"show\":\"\",\"when\":\"\",\"json\":\"\"},\"reorder\":false,\"properties\":{},\"customConditional\":\"\",\"logic\":[],\"attributes\":{}},{\"type\":\"button\",\"label\":\"Submit\",\"key\":\"submit\",\"disableOnInvalid\":true,\"theme\":\"primary\",\"input\":true,\"tableView\":true}]}";
            return result;
        }
        private LoggedInContext GetLoggedInContext()
        {
            var loggedInContext = this._fixture.Create<LoggedInContext>();
            return loggedInContext;
        }
        private IDataSetService GetInstance()
        {
            return new DataSetService(new DataSetFakeRepository());
        }
        private IDataSetService GetDataSetInstance()
        {
            return new DataSetService(new DataSetFakeRepository());
        }
        [Test]
        public void SearchDataSource_SuccessfullyReturn()
        {
            // Arrange
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            DataSourceSearchCriteriaInputModel dataSourceUpsertInputModel = new DataSourceSearchCriteriaInputModel();
            dataSourceUpsertInputModel.IsArchived = false;
            //IDataSourceService dataSource = this.GetInstance();
            // Act

            //var result = dataSource.SearchDataSource(dataSourceUpsertInputModel, loggedInContext, new List<ValidationMessage>());
            //var expectedResult = SearchDataSourceData();
            // Assert
           //AreEqualByJson(expectedResult, result);
        }
        [Test]
        public void SearchDataSource_UnSuccessfullyReturn()
        {
            // Arrange
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            DataSourceSearchCriteriaInputModel dataSourceUpsertInputModel = new DataSourceSearchCriteriaInputModel();
            dataSourceUpsertInputModel.IsArchived = null;
           // IDataSourceService dataSource = this.GetInstance();
           // var validationMessages = new List<ValidationMessage>();
            // Act

            //var result = dataSource.SearchDataSource(dataSourceUpsertInputModel, loggedInContext, validationMessages);
            // Assert
            //Assert.AreEqual(false, validationMessages.Count == 0);
        }
        public List<DataSourceOutputModel> SearchDataSourceData()
        {
            return new List<DataSourceOutputModel>
            {
                new DataSourceOutputModel
                {
                    Id = new Guid("9d7db5b8-2eb0-41e8-ac40-fa91731be7d8"),
                    FormTypeId = new Guid("06c5d24a-1b26-48c7-b8b5-4a2bade3539c"),
                    Name = "vv",
                    Fields = 
                        "{\"components\":[{\"label\":\"Text Field\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"textField2\",\"placeholder\":null,\"defaultValue\":\"\",\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null},{\"label\":\"Columns\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"columns2\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":[{\"components\":[{\"label\":\"\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"table2\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":[[{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[{\"label\":\"Tabs\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"tabs\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[{\"label\":\"Tab 1\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"tab1\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[{\"label\":\"Text Field\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"textField3\",\"placeholder\":null,\"defaultValue\":\"\",\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null}]},{\"label\":\"tab2\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"tab2\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null}]}]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]}],[{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]}],[{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]}]],\"components\":null}],\"type\":null,\"input\":false,\"key\":\"column\",\"label\":\"Column\",\"placeholder\":null,\"defaultValue\":null,\"customDefaultValue\":null,\"columns\":null,\"rows\":null},{\"components\":[],\"type\":null,\"input\":false,\"key\":\"column\",\"label\":\"Column\",\"placeholder\":null,\"defaultValue\":null,\"customDefaultValue\":null,\"columns\":null,\"rows\":null}],\"rows\":null,\"components\":null},{\"label\":\"Submit\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"submit\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null}]}",
                    IsArchived = false
                }
            };
        }
        [Test]
        public void CreateDataSetSubmitted_Successfully_ReturnId()
        {
            // Arrange
            DataSetUpsertInputModel formSubmitModel = GetDataSetUpsertInputModel();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IDataSetService dataSetService = this.GetDataSetInstance();
            // Act

           // var result = dataSetService.CreateDataSet(formSubmitModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            //Assert.AreEqual(new Guid("89eba5de-dcdf-4243-a2a4-81d3ab39a834"), result);
        }
        private DataSetUpsertInputModel GetDataSetUpsertInputModel()
        {
            DataSetUpsertInputModel result = new DataSetUpsertInputModel();
            result.DataSourceId = new Guid("a27f8b18-34ae-4956-8631-8a679c6db673");
            //result.DataJson = "{\"textField2\":\"asd\",\"textArea2\":\"asd\",\"radio3\":\"\",\"textArea3\":\"asd\",\"radio2\":\"\",\"submit\":true}";
            return result;
        }
        [TestCase(null, null, null, null, null)]
        [TestCase("", "", "", "71BE325F-2945-48DF-AD32-417271712A2D", null)]
        [TestCase("", "", "", null, "D1EE5E51-EF72-496B-B6FB-4011EC7B367B")]
        [TestCase("", "", "{\"textField2\":\"asd\",\"textArea2\":\"asd\",\"radio3\":\"\",\"textArea3\":\"asd\",\"radio2\":\"\",\"submit\":true}",  "", null)]
        [TestCase("", "", "{\"textField2\":\"asd\",\"textArea2\":\"asd\",\"radio3\":\"\",\"textArea3\":\"asd\",\"radio2\":\"\",\"submit\":true}", null, "")]
        [TestCase("", "", "", "", "")]
        public void CreateDataSet_UnSuccessfully_ReturnId(string customApplicationId, string formId,
            string fields, string companyGuid, string loggedInUserId)
        {
            // Arrange
            DataSetUpsertInputModel dataSourceUpsertInputModel = this.GetDataSetUpsertInputModel();
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            loggedInContext.CompanyGuid = companyGuid != null && companyGuid != "" ? new Guid(companyGuid) : Guid.Empty;
            loggedInContext.LoggedInUserId = loggedInUserId != null && loggedInUserId != ""?new Guid(loggedInUserId) :Guid.Empty;
            IDataSetService dataSetService = this.GetDataSetInstance();
            dataSourceUpsertInputModel.DataSourceId = customApplicationId != null ? new Guid("5D893EB5-CDE3-45E0-9290-2382220CB704") : null;
            dataSourceUpsertInputModel.Id = formId != null ? new Guid("5D893EB5-CDE3-45E0-9290-2382220CB704") : null;
           // dataSourceUpsertInputModel.DataJson = fields;
            // Act
            var validationMessages = new List<ValidationMessage>();
           // var result = dataSetService.CreateDataSet(dataSourceUpsertInputModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(false, validationMessages.Count == 0);
        }
        [TestCase(null, null, "5D893EB5-CDE3-45E0-9290-2382220CB704")]
        [TestCase(true, "a27f8b18-34ae-4956-8631-8a679c6db673", "5D893EB5-CDE3-45E0-9290-2382220CB704")]
        [TestCase(false, null, "5D893EB5-CDE3-45E0-9290-2382220CB704")]
        public void SearchDataSets_SuccessfullyReturn(bool isArchived, string id, string formTypeId)
        {
            // Arrange
            DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel = new DataSetSearchCriteriaInputModel();
            dataSetSearchCriteriaInputModel.IsArchived = isArchived;
            dataSetSearchCriteriaInputModel.Id = id != null? new Guid(id) :Guid.Empty;
            dataSetSearchCriteriaInputModel.DataSourceId = formTypeId != null ? new Guid(formTypeId) : Guid.Empty;
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IDataSetService dataSetService = this.GetDataSetInstance();
            // Act

            var result = dataSetService.SearchDataSets(dataSetSearchCriteriaInputModel, loggedInContext, new List<ValidationMessage>());
            var expectedResult = DataSetOutput();
            // Assert
            AreEqualByJson(expectedResult, result);
        }
        [TestCase(null, null, "5D893EB5-CDE3-45E0-9290-2382220CB704")]
        public void SearchDataSets_UnSuccessfullyReturn(bool? isArchived, string id, string formTypeId)
        {
            // Arrange
            DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel = new DataSetSearchCriteriaInputModel();
            dataSetSearchCriteriaInputModel.IsArchived = isArchived;
            dataSetSearchCriteriaInputModel.Id = id != null ? new Guid(id) : Guid.Empty;
            dataSetSearchCriteriaInputModel.DataSourceId = formTypeId != null ? new Guid(formTypeId) : Guid.Empty;
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            var validationMessages = new List<ValidationMessage>();
            IDataSetService dataSetService = this.GetDataSetInstance();
            // Act

            var result = dataSetService.SearchDataSets(dataSetSearchCriteriaInputModel, loggedInContext, validationMessages);
            // Assert
            Assert.AreEqual(false, validationMessages.Count == 0);
        }
        [Test]
        public void GetDataSetById_SuccessfullyReturn()
        {
            // Arrange
            Guid id = new Guid("3B3DE008-7F82-4ADF-A867-8827A99CE596");
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IDataSetService dataSetService = this.GetDataSetInstance();
            // Act

            var result = dataSetService.GetDataSetsById(id, loggedInContext, new List<ValidationMessage>());
            var expectedResult = DataSetOutput();
            // Assert
            AreEqualByJson(expectedResult, result);
        }
        [Test]
        public void GetDataSetById_UnSuccessfullyReturn()
        {
            // Arrange
            Guid id = Guid.Empty;
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            var validationMessages = new List<ValidationMessage>();
            IDataSetService dataSetService = this.GetDataSetInstance();
            // Act

            var result = dataSetService.GetDataSetsById(id, loggedInContext, validationMessages);
            // Assert
            Assert.AreEqual(false, validationMessages.Count == 0);
        }
        public static void AreEqualByJson(object expected, object actual)
        {
            var expectedJson = JsonConvert.SerializeObject(expected);
            var actualJson = JsonConvert.SerializeObject(actual);
            Assert.AreEqual(expectedJson, actualJson);
        }
        public List<DataSetOutputModel> DataSetOutput()
        {
            List<DataSetOutputModel> returnResult = new List<DataSetOutputModel>();
            DataSetOutputModel result = new DataSetOutputModel();
            result.DataSourceId = new Guid("88199da5-1f54-45f2-8990-657b4337a715");
            result.Id = new Guid("89eba5de-dcdf-4243-a2a4-81d3ab39a834");
            result.DataJson = "{\"textField2\":\"asd\",\"textArea2\":\"asd\",\"radio3\":\"\",\"textArea3\":\"asd\",\"radio2\":\"\",\"submit\":true}";
            returnResult.Add(result);
            return returnResult;
        }
    }
}
