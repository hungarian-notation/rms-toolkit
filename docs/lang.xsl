<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt">
  <xsl:output
    method="html"
    version="5.0"
    encoding="UTF-8"
    indent="yes"/>

  <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

  <xsl:template name="compute-navigable">
    <xsl:param name="parent"/>

    <!--
      All nodes that should be walked while looking for navigables should
      be declared here.
    -->
    <xsl:message><xsl:value-of select="name()"/></xsl:message>
    <xsl:variable name="shouldWalk">
      <xsl:choose>
        <xsl:when test="name()='section'">true</xsl:when>
        <xsl:when test="name()='topic'">true</xsl:when>
        <xsl:when test="name()='syntax-group'">true</xsl:when>
        <xsl:when test="name()='syntax'">true</xsl:when>
        <xsl:when test="name()='construct'">true</xsl:when>
        <xsl:when test="name()='record'">true</xsl:when>
        <xsl:when test="name()='data'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$shouldWalk='true'">

      <xsl:variable name="label">
        <xsl:choose>
          <xsl:when test="name()='section'"></xsl:when>
          <xsl:when test="name()='topic'"></xsl:when>
          <xsl:when test="name()='syntax-group'"></xsl:when>
          <xsl:when test="name()='syntax'"><xsl:value-of select="@type"/></xsl:when>
          <xsl:when test="name()='construct'">construct</xsl:when>
          <xsl:when test="name()='data'"></xsl:when>
          <xsl:when test="name()='record'"></xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>


      <xsl:variable name="anchor">
        <xsl:if test="$parent!=''"><xsl:value-of select="$parent"/>-</xsl:if><xsl:choose>
          <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
          <xsl:when test="@section"><xsl:value-of select="@section"/></xsl:when>
          <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
          <xsl:when test="./name"><xsl:value-of select="./name"/></xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!--
        Determine how to display the section in the navigation hierarchy.
      -->
      <xsl:variable name="displayName">
        <xsl:choose>
          <xsl:when test="@section"><xsl:value-of select="@section"/></xsl:when>
          <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
          <xsl:when test="./name"><xsl:value-of select="./name"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:if test="$displayName!=''">
        <navigable as="{$anchor}" name="{$displayName}" label="{$label}">
          <xsl:for-each select="./*">
            <xsl:call-template name="compute-navigable">
              <xsl:with-param name="parent" select="$anchor"/>
            </xsl:call-template>
          </xsl:for-each>
        </navigable>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:variable name="nav">
    <navigable as="top" name="top" nav-root="true">
      <xsl:for-each select="/lang/*">
        <xsl:call-template name="compute-navigable"/>
      </xsl:for-each>
    </navigable>
  </xsl:variable>

  <xsl:template match="navigable">
    <xsl:variable name="link-class">
      <xsl:choose>
        <xsl:when test="@label != ''">nav-link nav-link--<xsl:value-of select="@label"/></xsl:when>
        <xsl:otherwise>nav-link</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="not(@nav-root)">
      <li>
        <xsl:if test="@label != ''">
          <span class="nav-label nav-label--{@label}"><xsl:value-of select="@label"/></span>
        </xsl:if>
        <a href="#{@as}" class="{$link-class}">
          <xsl:value-of select="@name"/>
        </a>
      </li>
    </xsl:if>

    <xsl:if test="./navigable">
      <ul><xsl:apply-templates select="./navigable"/></ul>
    </xsl:if>
  </xsl:template>

  <xsl:template name="info">
    <div class="info details">
      <xsl:choose>
        <xsl:when test="info/p">
          <xsl:copy-of select="info/*"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- short format info tag -->
          <p><xsl:value-of select="info"/></p>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="lang">
    <html>
      <head>
        <link href="https://fonts.googleapis.com/css?family=Roboto+Mono:400,700|Roboto:400,400i,700,700i&amp;display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
        <link rel="stylesheet" type="text/css" href="style/lang.xsl.css"/>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="js/lang.xsl.js" type="module"></script>
      </head>
      <body>
        <div id="page">
          <header>
            <h1>Age of Empires II - Random Map Script Syntax</h1>
          </header>

          <div id="wrapper">
            <nav>
              <xsl:apply-templates select="exslt:node-set($nav)"/>
            </nav>
            <main>
              <div id="content-wrapper">
                <xsl:for-each select="./*">
                  <xsl:if test="name()='syntax-group'">
                    <xsl:call-template name="section-template"/>
                  </xsl:if>

                  <xsl:if test="name()='section'">
                    <xsl:call-template name="section-template"/>
                  </xsl:if>

                  <xsl:if test="name()='data'">
                    <xsl:call-template name="section-template"/>
                  </xsl:if>
                </xsl:for-each>
              </div>
            </main>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>


  <xsl:template name="section-template" match="syntax-group | section">                                             <!-- SYNTAX-GROUP TEMPLATE -->
    <xsl:variable name="groupName">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:when test="@section"><xsl:value-of select="@section"/></xsl:when>

        <xsl:when test="name()='data'">data</xsl:when>
        <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
        <xsl:when test="./name"><xsl:value-of select="./name"/></xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!--
      Determine how to display the section in the navigation hierarchy.
    -->
    <xsl:variable name="displayName">
      <xsl:choose>
        <xsl:when test="@section"><xsl:value-of select="@section"/></xsl:when>

        <xsl:when test="name()='data'">Appendix</xsl:when>
        <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
        <xsl:when test="./name"><xsl:value-of select="./name"/></xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <section name="{$displayName}" id="{$groupName}" class="{name()}">
      <h2><xsl:value-of select="$displayName"/></h2>

      <xsl:if test="./info">
        <xsl:call-template name="info"/>
      </xsl:if>

      <xsl:if test="./record">
        <xsl:for-each select="./record">
           <xsl:call-template name="record">
              <xsl:with-param name="groupName" select="$groupName"/>
           </xsl:call-template>
        </xsl:for-each>
      </xsl:if>


      <xsl:if test="./topic">
        <xsl:for-each select="./topic">
           <xsl:call-template name="topic">
              <xsl:with-param name="groupName" select="$groupName"/>
           </xsl:call-template>
        </xsl:for-each>
      </xsl:if>

      <xsl:if test="./construct">
        <h3>Constructs</h3>
        <xsl:for-each select="./construct">
           <xsl:call-template name="construct-topic">
              <xsl:with-param name="groupName" select="$groupName"/>
           </xsl:call-template>
        </xsl:for-each>
      </xsl:if>

      <xsl:if test="./syntax">
        <h3>Syntax</h3>
        <xsl:for-each select="./syntax">
           <xsl:call-template name="syntax-topic">
              <xsl:with-param name="groupName" select="$groupName"/>
           </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
    </section>
  </xsl:template>

  <xsl:template name="topic">                              <!-- TOPIC TEMPLATE -->
    <xsl:param name="groupName"/>

    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
        <xsl:when test="name"><xsl:value-of select="name"/></xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="displayName">
      <xsl:choose>
        <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
        <xsl:when test="name"><xsl:value-of select="name"/></xsl:when>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
      </xsl:choose>
    </xsl:variable>

    <div data-local-id="{$name}" id="{translate($groupName, $uppercase, $lowercase)}-{$name}" class="topic topic-type--general">
      <h4>
        <xsl:value-of select="$displayName"/>
      </h4>
      <xsl:call-template name="details"/>
      <xsl:call-template name="notes"/>
      <xsl:call-template name="exclusive"/>
    </div>
  </xsl:template>

  <xsl:template name="record" match="data/record">               <!-- APPENDIX TEMPLATE -->
    <xsl:param name="groupName"/>

    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
        <xsl:when test="name"><xsl:value-of select="name"/></xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="displayName">
      <xsl:choose>
        <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
        <xsl:when test="name"><xsl:value-of select="name"/></xsl:when>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
      </xsl:choose>
    </xsl:variable>

    <div data-local-id="{$name}" id="{translate($groupName, $uppercase, $lowercase)}-{$name}" class="record topic-type--record">
      <h4>
        <xsl:value-of select="$displayName"/>
      </h4>
      <xsl:call-template name="details"/>
      <xsl:call-template name="notes"/>
      <xsl:call-template name="exclusive"/>

      <ul>
        <xsl:for-each select="values/value">

          <xsl:variable name="value-name">
            <xsl:choose>
              <xsl:when test="name">
                <xsl:value-of select="name"/>
              </xsl:when>
              <xsl:when test="@name">
                <xsl:value-of select="@name"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>

          <li class="value {@class}">
            <xsl:choose>
              <xsl:when test="$value-name!=''">
                <xsl:value-of select="$value-name"/>
                <ul>
                  <xsl:for-each select="./*">
                    <xsl:if test="name()!='name'">
                      <li><strong><xsl:value-of select="name()"/>: </strong> <xsl:value-of select="."/></li>
                    </xsl:if>
                  </xsl:for-each>
                </ul>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </li>
        </xsl:for-each>
      </ul>

    </div>
  </xsl:template>

  <xsl:template name="construct-topic" match="syntax-group/syntax">               <!-- CONSTRUCT TEMPLATE -->
    <xsl:param name="groupName"/>
    <xsl:variable name="topicType">construct</xsl:variable>
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:when test="name"><xsl:value-of select="name"/></xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="displayName" select="name"/>
    <xsl:variable name="displayTopicType">Construct</xsl:variable>

    <div data-local-id="{$name}" id="{translate($groupName, $uppercase, $lowercase)}-{$name}" class="topic topic-type--{$topicType}">
      <h4>
        <span class="topic-type-label"><xsl:value-of select="$displayTopicType"/>:</span>
        <code><xsl:value-of select="./name"/></code>
      </h4>

      <xsl:call-template name="arguments"/>
      <xsl:call-template name="details"/>
      <xsl:call-template name="notes"/>
      <xsl:call-template name="exclusive"/>
    </div>
  </xsl:template>

  <xsl:template name="syntax-topic" match="syntax-group/syntax">                  <!-- SYNTAX TEMPLATE -->
    <xsl:param name="groupName"/>
    <xsl:param name="topicType" select="@type"/>

    <xsl:variable name="displayTopicType">
      <xsl:choose>
        <xsl:when test="$topicType='macro'">Macro</xsl:when>
        <xsl:when test="$topicType='command'">Command</xsl:when>
        <xsl:when test="$topicType='attribute'">Attribute</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="syntax-name" select="name"/>

    <xsl:variable name="syntax-params">
      <xsl:for-each select="./argument">
        <span title="{./type/@name}">
          <code class="syntax-param">
            <xsl:value-of select="name"/>
          </code>
        </span>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="syntax-id">
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:value-of select="@id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div data-local-id="{$syntax-id}" id="{translate($groupName, $uppercase, $lowercase)}-{$syntax-id}" class="topic topic-type--{$topicType}">
      <h4>
        <span class="topic-type-label"><xsl:value-of select="$displayTopicType"/>:</span>
        <code><xsl:value-of select="./name"/></code>
        <xsl:copy-of select="$syntax-params"/>
      </h4>

      <xsl:call-template name="arguments"/>
      <xsl:call-template name="details"/>
      <xsl:call-template name="notes"/>
      <xsl:call-template name="exclusive"/>

    </div>
  </xsl:template>                                                                <!-- end syntax-group/syntax -->

  <xsl:template name="exclusive">
    <xsl:if test="./exclude">
      <div class="syntax-note syntax-excludes">
        <p>mutually exclusive with:
          <xsl:for-each select="./exclude">
            <xsl:call-template name="exclusive-term"/>
          </xsl:for-each>
        </p>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="exclusive-term">
    <xsl:if test="position()!='1'">, </xsl:if><doc-ref target="{@target}"/>
  </xsl:template>

  <xsl:template name="details">
    <xsl:if test="info">
      <div class="topic-details">
        <xsl:call-template name="info"/>
      </div>
    </xsl:if>

    <xsl:if test="see">
      <xsl:for-each select="./see">
        <xsl:variable name="otherId">
          <xsl:choose>
            <xsl:when test="@target"><xsl:value-of select="@target"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="otherName">
          <xsl:value-of select="."/>
        </xsl:variable>
        <div class="topic-details">
          See <doc-ref target="{$otherId}" data-display-name="{$otherName}"/> for more information.
        </div>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="arguments">
    <xsl:if test="./argument">
      <div class="syntax-arguments">
        <dl>
          <xsl:for-each select="./argument">
            <xsl:call-template name="argument-detail"/>
          </xsl:for-each>
        </dl>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="notes">
    <xsl:for-each select="./note">
      <xsl:variable name="note-type" select="@class"/>
      <div class="syntax-note syntax-note--explicit syntax-note--{$note-type}">
        <p class="material-icons--before">
          <xsl:choose>
            <xsl:when test="$note-type='new'">
              New in AoE II: DE
            </xsl:when>
            <xsl:when test="$note-type='undocumented'">
              This feature is not listed in official documentation.
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </p>
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="argument-detail" match="syntax-group/syntax/argument">
    <dt data-argument-index="{position()}" data-argument-name="{name}">
      <code><xsl:value-of select="name"/></code>
      <span class="argument--type">
        <xsl:variable name="type-name">
          <xsl:choose>
            <xsl:when test="type/@name">
              <xsl:value-of select="type/@name"/>
              <xsl:if test="type/@domain">
                &#160;<span class="argument--type-domain">(<xsl:value-of select="type/@domain"/>)</span>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="type"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:copy-of select="$type-name"/>

        <xsl:if test="type/@min | type/@max">
          <xsl:variable name="min-value">
            <xsl:choose>
              <xsl:when test="type/@min"><xsl:value-of select="type/@min"/></xsl:when>
              <xsl:otherwise>&#45;&#8734;</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="max-value">
            <xsl:choose>
              <xsl:when test="type/@max"><xsl:value-of select="type/@max"/></xsl:when>
              <xsl:otherwise>&#43;&#8734;</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <span class="type-range">[<xsl:value-of select="$min-value"/>, <xsl:value-of select="$max-value"/>]</span>
        </xsl:if>
      </span>
      <xsl:if test="default">
        <span class="argument--default">default = <code><xsl:value-of select="default"/></code></span>
      </xsl:if>
    </dt>
    <dd>
      <span class="argument--details">
        <xsl:call-template name="info"/>
      </span>
    </dd>
  </xsl:template>

</xsl:stylesheet>
