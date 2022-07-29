<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyLocal="1" simplifyDrawingHints="1" simplifyAlgorithm="0" minScale="1e+08" simplifyMaxScale="1" labelsEnabled="0" hasScaleBasedVisibilityFlag="0" readOnly="0" version="3.6.2-Noosa" maxScale="100000" simplifyDrawingTol="1" styleCategories="AllStyleCategories">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 enableorderby="0" type="RuleRenderer" forceraster="0" symbollevels="0">
    <rules key="{b07c8a28-a680-4313-af27-ddccebb7a745}">
      <rule key="{f67b6c0a-fc6e-4151-ae6f-9b0fdb01e78e}" symbol="0" filter="&quot;WLS&quot;>-9999 AND &quot;WLS&quot; &lt;= -3" label="Recul sup. à 3 m/an"/>
      <rule key="{5df2b550-852a-45a9-b341-89ab38cf5259}" symbol="1" filter=" &quot;WLS&quot; >-3 AND  &quot;WLS&quot; &lt;=-1.5 " label="Recul entre 1,5 et 3 m/an"/>
      <rule key="{17498a50-8d15-439c-bec0-99ce50cd947a}" symbol="2" filter=" &quot;WLS&quot; > -1.5 AND  &quot;WLS&quot; &lt;=-0.5" label="Recul entre 0,5 et 1,5 m/an"/>
      <rule key="{5ddb8522-33a5-4ff7-b58b-629086e88eb6}" symbol="3" filter=" &quot;WLS&quot; >-0.5 AND  &quot;WLS&quot; &lt;0" label="Recul entre 0 et 0,5 m/an"/>
      <rule key="{315bfe51-3028-4724-bcb9-31be74aa3431}" symbol="4" filter=" &quot;WLS&quot; =0" label="Non perceptible"/>
      <rule key="{17175d52-2c10-408e-b46a-b735eb8ca04d}" symbol="5" filter=" &quot;WLS&quot; >0 AND  &quot;WLS&quot; &lt;0.5 " label="Avancée entre 0 et 0,5 m/an"/>
      <rule key="{75412db4-032b-47a4-a459-fc55db693341}" symbol="6" filter=" &quot;WLS&quot; >=0.5 AND  &quot;WLS&quot; &lt;1.5 " label="Avancée entre 0,5 et 1,5 m/an"/>
      <rule key="{4ee3e62b-6a06-44bb-9ece-f64bce343682}" symbol="7" filter=" &quot;WLS&quot; >=1.5 AND &quot;WLS&quot; &lt;3 " label="Avancée entre 1,5 et 3 m/an"/>
      <rule key="{a194cb80-abf4-4df7-9006-bbb5ef731043}" symbol="8" filter=" &quot;WLS&quot; >=3 " label="Avancée sup. à 3 m/an"/>
      <rule checkstate="0" key="{419bb187-c7a9-44b5-964f-82e5fc0cd272}" symbol="9" filter=" &quot;Taux&quot;  = -9999 AND  &quot;amenagemen&quot; =0" label="Pas de calcul (pas de donnée ou marqueur différent)"/>
      <rule checkstate="0" key="{1d912fc0-de40-4f13-80a5-5d1903ad4c97}" symbol="10" filter=" &quot;Taux&quot;  = -9999 AND  &quot;amenagemen&quot; =1" label="Pas de calcul (ouvrage au niveau du profil de calcul)"/>
    </rules>
    <symbols>
      <symbol alpha="1" type="fill" name="0" clip_to_extent="1" force_rhr="0">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop v="3x:0,0,0,0,0,0" k="border_width_map_unit_scale"/>
          <prop v="167,79,15,255" k="color"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="167,79,15,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.2" k="outline_width"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="solid" k="style"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" type="fill" name="1" clip_to_extent="1" force_rhr="0">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop v="3x:0,0,0,0,0,0" k="border_width_map_unit_scale"/>
          <prop v="190,118,46,255" k="color"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="190,118,46,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.2" k="outline_width"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="solid" k="style"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" type="fill" name="10" clip_to_extent="1" force_rhr="0">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop v="3x:0,0,0,0,0,0" k="border_width_map_unit_scale"/>
          <prop v="80,170,202,255" k="color"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="no" k="outline_style"/>
          <prop v="0.26" k="outline_width"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="no" k="style"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" type="fill" name="2" clip_to_extent="1" force_rhr="0">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop v="3x:0,0,0,0,0,0" k="border_width_map_unit_scale"/>
          <prop v="245,150,80,255" k="color"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="245,150,80,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.2" k="outline_width"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="solid" k="style"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" type="fill" name="3" clip_to_extent="1" force_rhr="0">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop v="3x:0,0,0,0,0,0" k="border_width_map_unit_scale"/>
          <prop v="254,222,154,255" k="color"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="254,222,154,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.2" k="outline_width"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="solid" k="style"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" type="fill" name="4" clip_to_extent="1" force_rhr="0">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop v="3x:0,0,0,0,0,0" k="border_width_map_unit_scale"/>
          <prop v="171,250,240,255" k="color"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="171,250,240,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.2" k="outline_width"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="solid" k="style"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" type="fill" name="5" clip_to_extent="1" force_rhr="0">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop v="3x:0,0,0,0,0,0" k="border_width_map_unit_scale"/>
          <prop v="219,239,157,255" k="color"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="219,239,157,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.2" k="outline_width"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="solid" k="style"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" type="fill" name="6" clip_to_extent="1" force_rhr="0">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop v="3x:0,0,0,0,0,0" k="border_width_map_unit_scale"/>
          <prop v="137,203,97,255" k="color"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="137,203,97,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.2" k="outline_width"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="solid" k="style"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" type="fill" name="7" clip_to_extent="1" force_rhr="0">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop v="3x:0,0,0,0,0,0" k="border_width_map_unit_scale"/>
          <prop v="28,166,70,255" k="color"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="28,166,70,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.2" k="outline_width"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="solid" k="style"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" type="fill" name="8" clip_to_extent="1" force_rhr="0">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop v="3x:0,0,0,0,0,0" k="border_width_map_unit_scale"/>
          <prop v="0,105,0,255" k="color"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,105,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.2" k="outline_width"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="solid" k="style"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" type="fill" name="9" clip_to_extent="1" force_rhr="0">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop v="3x:0,0,0,0,0,0" k="border_width_map_unit_scale"/>
          <prop v="145,145,145,255" k="color"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="145,145,145,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.2" k="outline_width"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="solid" k="style"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <customproperties>
    <property key="dualview/previewExpressions" value="NAxe"/>
    <property key="embeddedWidgets/count" value="0"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory backgroundColor="#ffffff" opacity="1" penColor="#000000" scaleBasedVisibility="0" maxScaleDenominator="1e+08" scaleDependency="Area" barWidth="5" penAlpha="255" penWidth="0" sizeScale="3x:0,0,0,0,0,0" enabled="0" backgroundAlpha="255" lineSizeType="MM" minimumSize="0" height="15" rotationOffset="270" labelPlacementMethod="XHeight" diagramOrientation="Up" width="15" lineSizeScale="3x:0,0,0,0,0,0" minScaleDenominator="100000" sizeType="MM">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute color="#000000" field="" label=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings placement="1" obstacle="0" dist="0" priority="0" showAll="1" linePlacementFlags="18" zIndex="0">
    <properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="NAxe">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="NTrace">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="Loc">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="Xsque">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="Ysque">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="U">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="V">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="Angle">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="NDate">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="Duree">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="Amplitd">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="DtTDCvx">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="DtTDCrc">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="Marquer">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="EPR">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="AOR">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="OLS">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="WLS">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="RLS">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="RWLS">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="JK">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="K">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="MDL">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="DateK">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="Product">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="DatePrd">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
            <Option type="bool" name="UseHtml" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="nom_png">
      <editWidget type="ExternalResource">
        <config>
          <Option type="Map">
            <Option type="QString" name="DefaultRoot" value="C:/0_ENCOURS/MOBITC/DEPT06"/>
            <Option type="int" name="DocumentViewer" value="1"/>
            <Option type="int" name="DocumentViewerHeight" value="0"/>
            <Option type="int" name="DocumentViewerWidth" value="0"/>
            <Option type="bool" name="FileWidget" value="true"/>
            <Option type="bool" name="FileWidgetButton" value="false"/>
            <Option type="QString" name="FileWidgetFilter" value=""/>
            <Option type="bool" name="FullUrl" value="true"/>
            <Option type="Map" name="PropertyCollection">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
            <Option type="int" name="RelativeStorage" value="1"/>
            <Option type="int" name="StorageMode" value="0"/>
            <Option type="bool" name="UseLink" value="true"/>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="NAxe" name="" index="0"/>
    <alias field="NTrace" name="" index="1"/>
    <alias field="Loc" name="" index="2"/>
    <alias field="Xsque" name="" index="3"/>
    <alias field="Ysque" name="" index="4"/>
    <alias field="U" name="" index="5"/>
    <alias field="V" name="" index="6"/>
    <alias field="Angle" name="" index="7"/>
    <alias field="NDate" name="" index="8"/>
    <alias field="Duree" name="" index="9"/>
    <alias field="Amplitd" name="" index="10"/>
    <alias field="DtTDCvx" name="" index="11"/>
    <alias field="DtTDCrc" name="" index="12"/>
    <alias field="Marquer" name="" index="13"/>
    <alias field="EPR" name="" index="14"/>
    <alias field="AOR" name="" index="15"/>
    <alias field="OLS" name="" index="16"/>
    <alias field="WLS" name="" index="17"/>
    <alias field="RLS" name="" index="18"/>
    <alias field="RWLS" name="" index="19"/>
    <alias field="JK" name="" index="20"/>
    <alias field="K" name="" index="21"/>
    <alias field="MDL" name="" index="22"/>
    <alias field="DateK" name="" index="23"/>
    <alias field="Product" name="" index="24"/>
    <alias field="DatePrd" name="" index="25"/>
    <alias field="nom_png" name="graph" index="26"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default applyOnUpdate="0" expression="" field="NAxe"/>
    <default applyOnUpdate="0" expression="" field="NTrace"/>
    <default applyOnUpdate="0" expression="" field="Loc"/>
    <default applyOnUpdate="0" expression="" field="Xsque"/>
    <default applyOnUpdate="0" expression="" field="Ysque"/>
    <default applyOnUpdate="0" expression="" field="U"/>
    <default applyOnUpdate="0" expression="" field="V"/>
    <default applyOnUpdate="0" expression="" field="Angle"/>
    <default applyOnUpdate="0" expression="" field="NDate"/>
    <default applyOnUpdate="0" expression="" field="Duree"/>
    <default applyOnUpdate="0" expression="" field="Amplitd"/>
    <default applyOnUpdate="0" expression="" field="DtTDCvx"/>
    <default applyOnUpdate="0" expression="" field="DtTDCrc"/>
    <default applyOnUpdate="0" expression="" field="Marquer"/>
    <default applyOnUpdate="0" expression="" field="EPR"/>
    <default applyOnUpdate="0" expression="" field="AOR"/>
    <default applyOnUpdate="0" expression="" field="OLS"/>
    <default applyOnUpdate="0" expression="" field="WLS"/>
    <default applyOnUpdate="0" expression="" field="RLS"/>
    <default applyOnUpdate="0" expression="" field="RWLS"/>
    <default applyOnUpdate="0" expression="" field="JK"/>
    <default applyOnUpdate="0" expression="" field="K"/>
    <default applyOnUpdate="0" expression="" field="MDL"/>
    <default applyOnUpdate="0" expression="" field="DateK"/>
    <default applyOnUpdate="0" expression="" field="Product"/>
    <default applyOnUpdate="0" expression="" field="DatePrd"/>
    <default applyOnUpdate="0" expression="" field="nom_png"/>
  </defaults>
  <constraints>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="NAxe" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="NTrace" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="Loc" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="Xsque" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="Ysque" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="U" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="V" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="Angle" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="NDate" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="Duree" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="Amplitd" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="DtTDCvx" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="DtTDCrc" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="Marquer" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="EPR" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="AOR" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="OLS" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="WLS" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="RLS" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="RWLS" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="JK" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="K" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="MDL" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="DateK" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="Product" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="DatePrd" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="nom_png" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="NAxe" desc=""/>
    <constraint exp="" field="NTrace" desc=""/>
    <constraint exp="" field="Loc" desc=""/>
    <constraint exp="" field="Xsque" desc=""/>
    <constraint exp="" field="Ysque" desc=""/>
    <constraint exp="" field="U" desc=""/>
    <constraint exp="" field="V" desc=""/>
    <constraint exp="" field="Angle" desc=""/>
    <constraint exp="" field="NDate" desc=""/>
    <constraint exp="" field="Duree" desc=""/>
    <constraint exp="" field="Amplitd" desc=""/>
    <constraint exp="" field="DtTDCvx" desc=""/>
    <constraint exp="" field="DtTDCrc" desc=""/>
    <constraint exp="" field="Marquer" desc=""/>
    <constraint exp="" field="EPR" desc=""/>
    <constraint exp="" field="AOR" desc=""/>
    <constraint exp="" field="OLS" desc=""/>
    <constraint exp="" field="WLS" desc=""/>
    <constraint exp="" field="RLS" desc=""/>
    <constraint exp="" field="RWLS" desc=""/>
    <constraint exp="" field="JK" desc=""/>
    <constraint exp="" field="K" desc=""/>
    <constraint exp="" field="MDL" desc=""/>
    <constraint exp="" field="DateK" desc=""/>
    <constraint exp="" field="Product" desc=""/>
    <constraint exp="" field="DatePrd" desc=""/>
    <constraint exp="" field="nom_png" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortExpression="" sortOrder="0">
    <columns>
      <column type="actions" width="-1" hidden="1"/>
      <column type="field" width="-1" hidden="0" name="NAxe"/>
      <column type="field" width="-1" hidden="0" name="NTrace"/>
      <column type="field" width="-1" hidden="0" name="Xsque"/>
      <column type="field" width="-1" hidden="0" name="Ysque"/>
      <column type="field" width="-1" hidden="0" name="U"/>
      <column type="field" width="-1" hidden="0" name="V"/>
      <column type="field" width="-1" hidden="0" name="Angle"/>
      <column type="field" width="-1" hidden="0" name="NDate"/>
      <column type="field" width="-1" hidden="0" name="Duree"/>
      <column type="field" width="-1" hidden="0" name="Amplitd"/>
      <column type="field" width="-1" hidden="0" name="DtTDCvx"/>
      <column type="field" width="-1" hidden="0" name="DtTDCrc"/>
      <column type="field" width="-1" hidden="0" name="Marquer"/>
      <column type="field" width="-1" hidden="0" name="EPR"/>
      <column type="field" width="-1" hidden="0" name="AOR"/>
      <column type="field" width="-1" hidden="0" name="OLS"/>
      <column type="field" width="-1" hidden="0" name="WLS"/>
      <column type="field" width="-1" hidden="0" name="RLS"/>
      <column type="field" width="-1" hidden="0" name="RWLS"/>
      <column type="field" width="-1" hidden="0" name="JK"/>
      <column type="field" width="-1" hidden="0" name="K"/>
      <column type="field" width="-1" hidden="0" name="MDL"/>
      <column type="field" width="-1" hidden="0" name="DateK"/>
      <column type="field" width="-1" hidden="0" name="Product"/>
      <column type="field" width="-1" hidden="0" name="DatePrd"/>
      <column type="field" width="55" hidden="0" name="Loc"/>
      <column type="field" width="167" hidden="0" name="nom_png"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <editform tolerant="1">C:/PROGRA~1/QGIS3~1.6/bin</editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
Les formulaires QGIS peuvent avoir une fonction Python qui sera appelée à l'ouverture du formulaire.

Utilisez cette fonction pour ajouter plus de fonctionnalités à vos formulaires.

Entrez le nom de la fonction dans le champ "Fonction d'initialisation Python".
Voici un exemple à suivre:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
    geom = feature.geometry()
    control = dialog.findChild(QWidget, "MyLineEdit")

]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>tablayout</editorlayout>
  <attributeEditorForm>
    <attributeEditorField showLabel="1" name="NAxe" index="0"/>
    <attributeEditorField showLabel="1" name="NTrace" index="1"/>
    <attributeEditorField showLabel="1" name="Loc" index="2"/>
    <attributeEditorField showLabel="1" name="nom_png" index="26"/>
  </attributeEditorForm>
  <editable>
    <field editable="1" name="AOR"/>
    <field editable="1" name="Amplitd"/>
    <field editable="1" name="Angle"/>
    <field editable="1" name="DateK"/>
    <field editable="1" name="DatePrd"/>
    <field editable="1" name="DtTDCrc"/>
    <field editable="1" name="DtTDCvx"/>
    <field editable="1" name="Duree"/>
    <field editable="1" name="EPR"/>
    <field editable="1" name="JK"/>
    <field editable="1" name="K"/>
    <field editable="1" name="Loc"/>
    <field editable="1" name="MDL"/>
    <field editable="1" name="Marquer"/>
    <field editable="1" name="NAxe"/>
    <field editable="1" name="NDate"/>
    <field editable="1" name="NTrace"/>
    <field editable="1" name="OLS"/>
    <field editable="1" name="Product"/>
    <field editable="1" name="RLS"/>
    <field editable="1" name="RWLS"/>
    <field editable="1" name="U"/>
    <field editable="1" name="V"/>
    <field editable="1" name="WLS"/>
    <field editable="1" name="Xsque"/>
    <field editable="1" name="Ysque"/>
    <field editable="1" name="nom_png"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="AOR"/>
    <field labelOnTop="0" name="Amplitd"/>
    <field labelOnTop="0" name="Angle"/>
    <field labelOnTop="0" name="DateK"/>
    <field labelOnTop="0" name="DatePrd"/>
    <field labelOnTop="0" name="DtTDCrc"/>
    <field labelOnTop="0" name="DtTDCvx"/>
    <field labelOnTop="0" name="Duree"/>
    <field labelOnTop="0" name="EPR"/>
    <field labelOnTop="0" name="JK"/>
    <field labelOnTop="0" name="K"/>
    <field labelOnTop="0" name="Loc"/>
    <field labelOnTop="0" name="MDL"/>
    <field labelOnTop="0" name="Marquer"/>
    <field labelOnTop="0" name="NAxe"/>
    <field labelOnTop="0" name="NDate"/>
    <field labelOnTop="0" name="NTrace"/>
    <field labelOnTop="0" name="OLS"/>
    <field labelOnTop="0" name="Product"/>
    <field labelOnTop="0" name="RLS"/>
    <field labelOnTop="0" name="RWLS"/>
    <field labelOnTop="0" name="U"/>
    <field labelOnTop="0" name="V"/>
    <field labelOnTop="0" name="WLS"/>
    <field labelOnTop="0" name="Xsque"/>
    <field labelOnTop="0" name="Ysque"/>
    <field labelOnTop="0" name="nom_png"/>
  </labelOnTop>
  <widgets/>
  <previewExpression>NAxe</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>2</layerGeometryType>
</qgis>
