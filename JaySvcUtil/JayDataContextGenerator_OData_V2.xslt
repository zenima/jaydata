<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:edm="http://schemas.microsoft.com/ado/2008/09/edm" 
                xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" 
                xmlns:annot="http://schemas.microsoft.com/ado/2009/02/edm/annotation" 
                xmlns:exsl="http://exslt.org/common" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">

  <xsl:key name="entityType" match="edm:EntityType" use="concat(string(../@Namespace),'.', string(@Name))"/>
  <xsl:key name="associations" match="edm:Association" use="concat(string(../@Namespace),'.', string(@Name))"/>

  <xsl:strip-space elements="property item unprocessed"/>
  <xsl:output method="text" indent="no"  />
  <xsl:param name="contextNamespace" />

  <xsl:param name="SerivceUri" />
  <xsl:param name="EntityBaseClass"/>
  <xsl:param name="ContextBaseClass"/>
  <xsl:param name="AutoCreateContext"/>
  <xsl:param name="ContextInstanceName"/>
  <xsl:param name="EntitySetBaseClass"/>
  <xsl:param name="CollectionBaseClass"/>
  <xsl:param name="DefaultNamespace"/>

  <xsl:template match="/">

/*//////////////////////////////////////////////////////////////////////////////////////
////// Autogenerated by JaySvcUtil.exe http://JayData.org for more info        /////////
//////                             oData @@VERSION@@                                    /////////
//////////////////////////////////////////////////////////////////////////////////////*/
(function(global, $data, undefined) {
  <xsl:variable name="EdmJayTypeMapping">
    <map from="Edm.Boolean" to="$data.Boolean" />
    <map from="Edm.Binary" to="$data.Blob" />
    <map from="Edm.DateTime" to="$data.Date" />
    <map from="Edm.DateTimeOffset" to="$data.Integer" />
    <map from="Edm.Time" to="$data.Integer" />
    <map from="Edm.Decimal" to="$data.Number" />
    <map from="Edm.Single" to="$data.Number" />
    <map from="Edm.Double" to="$data.Number" />
    <map from="Edm.Guid" to="$data.String" />
    <map from="Edm.Int16" to="$data.Integer" />
    <map from="Edm.Int32" to="$data.Integer" />
    <map from="Edm.Int64" to="$data.Integer" />
    <map from="Edm.Byte" to="$data.Integer" />
    <map from="Edm.String" to="$data.String" />
    <map from="Edm.GeographyPoint" to="$data.Geography" />
  </xsl:variable>

  function registerEdmTypes() { <xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:for-each select="msxsl:node-set($EdmJayTypeMapping)/*">
        function <xsl:value-of select="translate(@from,'.','_')" />() { };
        $data.Container.registerType('<xsl:value-of select="@from"/>', <xsl:value-of select="translate(@from,'.','_')"/>);
        $data.Container.mapType(<xsl:value-of select="translate(@from,'.','_')" />, <xsl:value-of select="@to" />);
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>

      <xsl:for-each select="exsl:node-set($EdmJayTypeMapping)/*">
        function <xsl:value-of select="translate(@from,'.','_')" />() { };
        $data.Container.registerType('<xsl:value-of select="@from"/>', <xsl:value-of select="translate(@from,'.','_')"/>);
        $data.Container.mapType(<xsl:value-of select="translate(@from,'.','_')" />, <xsl:value-of select="@to" />);
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
  };
  registerEdmTypes();


<xsl:for-each select="//edm:EntityType | //edm:ComplexType" xml:space="default">
  <xsl:message terminate="no">Info: generating type <xsl:value-of select="concat(../@Namespace, '.', @Name)"/>
</xsl:message>
  <xsl:variable name="props">
    <xsl:apply-templates select="*" />
  </xsl:variable>
  <xsl:text xml:space="preserve">  </xsl:text><xsl:value-of select="$EntityBaseClass"  />.extend('<xsl:value-of select="concat($DefaultNamespace,../@Namespace)"/>.<xsl:value-of select="@Name"/>', {
    <xsl:choose><xsl:when test="function-available('msxsl:node-set')">
    <xsl:for-each select="msxsl:node-set($props)/*">
      <xsl:value-of select="."/><xsl:if test="position() != last()">,
    </xsl:if></xsl:for-each>
  </xsl:when>
  <xsl:otherwise>
    <xsl:for-each select="exsl:node-set($props)/*">
      <xsl:value-of select="."/><xsl:if test="position() != last()">,
    </xsl:if></xsl:for-each>
    </xsl:otherwise>
    </xsl:choose>
  });
  
</xsl:for-each>

<xsl:for-each select="//edm:EntityContainer">
  <xsl:text xml:space="preserve">  </xsl:text><xsl:value-of select="$ContextBaseClass"  />.extend('<xsl:value-of select="concat(concat($DefaultNamespace,../@Namespace), '.', @Name)"/>', {
    <xsl:for-each select="edm:EntitySet | edm:FunctionImport">
      <xsl:apply-templates select="."></xsl:apply-templates><xsl:if test="position() != last()">,
    </xsl:if>
    </xsl:for-each>
  });

  $data.generatedContexts = $data.generatedContexts || [];
  $data.generatedContexts.push(<xsl:value-of select="concat(concat($DefaultNamespace,../@Namespace), '.', @Name)" />);
  <xsl:if test="$AutoCreateContext = 'true'">
  /*Context Instance*/
  <xsl:value-of select="$DefaultNamespace"/><xsl:value-of select="$ContextInstanceName" /> = new <xsl:value-of select="concat(concat($DefaultNamespace,../@Namespace), '.', @Name)" />( { name:'oData', oDataServiceHost: '<xsl:value-of select="$SerivceUri" />' });
</xsl:if>

</xsl:for-each>
      
})(window, $data);
      
    </xsl:template>

  <xsl:template match="edm:Key"></xsl:template>

  <xsl:template match="edm:FunctionImport">'<xsl:value-of select="@Name"/>': $data.EntityContext.generateServiceOperation({ serviceName:'<xsl:value-of select="@Name"/>', returnType: <xsl:apply-templates select="." mode="render-return-config" />, <xsl:apply-templates select="." mode="render-elementType-config" />params: [<xsl:for-each select="edm:Parameter">{ <xsl:value-of select="@Name"/>: '<xsl:value-of select="@Type"/>' }<xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>], method: '<xsl:value-of select="@m:HttpMethod"/>' })</xsl:template>

  <xsl:template match="edm:FunctionImport" mode="render-return-config">
    <xsl:choose>
      <xsl:when test="not(@ReturnType)">null</xsl:when>
      <xsl:when test="starts-with(@ReturnType, 'Collection')">$data.Queryable</xsl:when>
      <xsl:otherwise> '<xsl:value-of select="@ReturnType"/>' </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="edm:FunctionImport" mode="render-elementType-config">
    <xsl:if test="starts-with(@ReturnType, 'Collection')">
      <xsl:variable name="len" select="string-length(@ReturnType)-12"/>elementType: '<xsl:value-of select="concat($DefaultNamespace,substring(@ReturnType,12,$len))"/>', </xsl:if>
  </xsl:template>

  <xsl:template match="edm:EntitySet">'<xsl:value-of select="@Name"/>': { type: <xsl:value-of select="$EntitySetBaseClass"  />, elementType: <xsl:value-of select="concat($DefaultNamespace,@EntityType)"/> }</xsl:template>
  
  <xsl:template match="edm:Property | edm:NavigationProperty">
    <property>
    <xsl:variable name="memberDefinition">
      <xsl:if test="parent::edm:EntityType/edm:Key/edm:PropertyRef[@Name = current()/@Name]"><attribute name="key">true</attribute></xsl:if>
      <xsl:apply-templates select="@*[local-name() != 'Name']" mode="render-field" />
    </xsl:variable>'<xsl:value-of select="@Name"/>': { <xsl:choose><xsl:when test="function-available('msxsl:node-set')"><xsl:for-each select="msxsl:node-set($memberDefinition)/*">'<xsl:if test="@extended = 'true'">$</xsl:if><xsl:value-of select="@name"/>':<xsl:value-of select="."/>
      <xsl:if test="position() != last()">,<xsl:text> </xsl:text>
    </xsl:if> </xsl:for-each></xsl:when>
  <xsl:otherwise><xsl:for-each select="exsl:node-set($memberDefinition)/*">'<xsl:if test="@extended = 'true'">$</xsl:if><xsl:value-of select="@name"/>':<xsl:value-of select="."/>
      <xsl:if test="position() != last()">,<xsl:text> </xsl:text>
    </xsl:if> </xsl:for-each></xsl:otherwise>
    </xsl:choose> }</property>
</xsl:template>
  
  <xsl:template match="@Name" mode="render-field">
  </xsl:template>

  <xsl:template match="@Type" mode="render-field">
    <xsl:choose>
      <xsl:when test="starts-with(., 'Collection')">
        <attribute name="type">'Array'</attribute>
        <xsl:variable name="len" select="string-length(.)-12"/>
        <attribute name="elementType">'<xsl:value-of select="$DefaultNamespace"/><xsl:value-of select="substring(.,12,$len)" />'</attribute>
      </xsl:when>
      <xsl:when test="starts-with(., ../../../@Namespace)">
        <attribute name="type">'<xsl:value-of select="$DefaultNamespace"/><xsl:value-of select="."/>'</attribute>
      </xsl:when>
      <xsl:otherwise>
        <attribute name="type">'<xsl:value-of select="."/>'</attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@ConcurrencyMode" mode="render-field">
    <attribute name="concurrencyMode">$data.ConcurrencyMode.<xsl:value-of select="."/></attribute>
  </xsl:template>

  <xsl:template match="@Nullable" mode="render-field">
    <attribute name="nullable"><xsl:value-of select="."/></attribute>
    
    <xsl:if test=". = 'false'">
      <xsl:choose>
        <xsl:when test="parent::edm:Property/@annot:StoreGeneratedPattern = 'Identity' or parent::edm:Property/@annot:StoreGeneratedPattern = 'Computed'"></xsl:when>
        <xsl:otherwise><attribute name="required">true</attribute></xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@annot:StoreGeneratedPattern" mode="render-field">
    <xsl:if test=". != 'None'"><attribute name="computed">true</attribute></xsl:if>    
  </xsl:template>

  <xsl:template match="@MaxLength" mode="render-field">
    <attribute name="maxLength">
      <xsl:choose>
        <xsl:when test="string(.) = 'Max'">Number.POSITIVE_INFINITY</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </attribute>
  </xsl:template>

  <xsl:template match="@FixedLength | @Unicode | @Precision | @Scale" mode="render-field">
  </xsl:template>
  <xsl:template match="@*" mode="render-field">
    <xsl:variable name="nameProp">
      <xsl:choose>
        <xsl:when test="substring-after(name(), ':') != ''">
          <xsl:value-of select="substring-after(name(), ':')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="name()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="attribute"><xsl:attribute name="extended">true</xsl:attribute><xsl:attribute name="name"><xsl:value-of select="$nameProp"/></xsl:attribute>'<xsl:value-of select="."/>'</xsl:element>
  </xsl:template>

  <xsl:template match="@Relationship" mode="render-field">
    <xsl:variable name="relationName" select="string(../@ToRole)"/>
    <xsl:variable name="relationshipName" select="string(.)" />
    <xsl:variable name="relation" select="key('associations',string(.))/edm:End[@Role = $relationName]" />
    <xsl:variable name="otherName" select="../@FromRole" />
    <xsl:variable name="otherProp" select="//edm:NavigationProperty[@ToRole = $otherName and @Relationship = $relationshipName]" />
    <xsl:variable name="m" select="$relation/@Multiplicity" />
    <xsl:choose>
      <xsl:when test="$m = '*'">
        <attribute name="type">'<xsl:value-of select="$CollectionBaseClass"/>'</attribute>
        <attribute name="elementType">'<xsl:value-of select="$DefaultNamespace"/><xsl:value-of select="$relation/@Type"/>'</attribute>
        <xsl:if test="not($otherProp/@Name)">
          <attribute name="inverseProperty">'$$unbound'</attribute></xsl:if>
        <xsl:if test="$otherProp/@Name">
          <attribute name="inverseProperty">'<xsl:value-of select="$otherProp/@Name"/>'</attribute></xsl:if>
      </xsl:when>
      <xsl:when test="$m = '0..1'">
        <attribute name="type">'<xsl:value-of select="$DefaultNamespace"/><xsl:value-of select="$relation/@Type"/>'</attribute>
        <xsl:choose>
          <xsl:when test="$otherProp">
            <attribute name="inverseProperty">'<xsl:value-of select="$otherProp/@Name"/>'</attribute>
          </xsl:when >
          <xsl:otherwise>
            <attribute name="inverseProperty">'$$unbound'</attribute>
            <xsl:message terminate="no">  Warning: inverseProperty other side missing: <xsl:value-of select="."/>
          </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$m = '1'">
        <attribute name="type">'<xsl:value-of select="$DefaultNamespace"/><xsl:value-of select="$relation/@Type"/>'</attribute>
        <attribute name="required">true</attribute>
        <xsl:choose>
          <xsl:when test="$otherProp">
            <attribute name="inverseProperty">'<xsl:value-of select="$otherProp/@Name"/>'</attribute>
          </xsl:when >
          <xsl:otherwise>
            <attribute name="inverseProperty">'$$unbound'</attribute>
            <xsl:message terminate="no">
              Warning: inverseProperty other side missing: <xsl:value-of select="."/>
            </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="@FromRole | @ToRole" mode="render-field"></xsl:template>

  <xsl:template match="*" mode="render-field">
    <!--<unprocessed>!!<xsl:value-of select="name()"/>!!</unprocessed>-->
    <xsl:message terminate="no">  Warning: <xsl:value-of select="../../@Name"/>.<xsl:value-of select="../@Name"/>:<xsl:value-of select="name()"/> is an unknown/unprocessed attribued</xsl:message>
  </xsl:template>
  <!--<xsl:template match="*">
    !<xsl:value-of select="name()"/>!
  </xsl:template>-->
</xsl:stylesheet>
