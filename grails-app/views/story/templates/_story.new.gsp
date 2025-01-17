%{--
- Copyright (c) 2015 Kagilum.
-
- This file is part of iceScrum.
-
- iceScrum is free software: you can redistribute it and/or modify
- it under the terms of the GNU Affero General Public License as published by
- the Free Software Foundation, either version 3 of the License.
-
- iceScrum is distributed in the hope that it will be useful,
- but WITHOUT ANY WARRANTY; without even the implied warranty of
- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- GNU General Public License for more details.
-
- You should have received a copy of the GNU Affero General Public License
- along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
-
- Authors:
-
- Vincent Barrier (vbarrier@kagilum.com)
- Nicolas Noullet (nnoullet@kagilum.com)
--}%
<script type="text/ng-template" id="story.new.html">
<div class="panel panel-light">
    <div class="panel-heading">
        <h3 class="panel-title row">
            <div class="left-title">
                <i class="fa fa-sticky-note" ng-style="{color: storyPreview.feature ? storyPreview.feature.color : '#f9f157'}"></i>
                <span class="item-name" title="${message(code: 'todo.is.ui.story.new')}">${message(code: 'todo.is.ui.story.new')}</span>
            </div>
            <div class="right-title">
                <details-layout-buttons ng-if="!isModal" remove-ancestor="true"/>
            </div>
        </h3>
    </div>
    <div class="details-no-tab">
        <div class="panel-body">
            <div class="help-block">
                ${message(code: 'is.ui.sandbox.help')}
                <documentation doc-url="features-stories-tasks#stories"/>
            </div>
            <div class="postits standalone">
                <div class="postit-container solo">
                    <div ng-style="(storyPreview.feature ? storyPreview.feature.color : '#f9f157') | createGradientBackground"
                         class="postit {{ ((storyPreview.feature ? storyPreview.feature.color : '#f9f157') | contrastColor) + ' ' + (storyPreview.type | storyType)}}">
                        <div class="head">
                            <div class="head-left">
                                <span class="id">42</span>
                            </div>
                        </div>
                        <div class="content">
                            <h3 class="title">{{ story.name }}</h3>
                            <div class="description-template"
                                 ng-bind-html="storyPreview.description"></div>
                        </div>
                        <div class="footer">
                            <div class="tags">
                                <a ng-repeat="tag in storyPreview.tags"
                                   href="{{ tagContextUrl(tag) }}">
                                    <span class="tag {{ getTagColor(tag, 'story') | contrastColor }}"
                                          ng-style="{'background-color': getTagColor(tag, 'story') }">{{:: tag }}</span>
                                </a>
                            </div>
                            <div class="actions">
                                <span class="action">
                                    <a defer-tooltip="${message(code: 'todo.is.ui.backlogelement.attachments')}">
                                        <i class="fa fa-paperclip"></i>
                                    </a>
                                </span>
                                <span class="action">
                                    <a defer-tooltip="${message(code: 'todo.is.ui.comments')}">
                                        <i class="fa fa-comment"></i>
                                    </a>
                                </span>
                                <span class="action" ng-class="{'active':storyPreview.tasks_count}">
                                    <a defer-tooltip="${message(code: 'todo.is.ui.tasks')}">
                                        <i class="fa fa-tasks"></i>
                                        <span class="badge">{{ storyPreview.tasks_count || '' }}</span>
                                    </a>
                                </span>
                                <span class="action" ng-class="{'active':storyPreview.acceptanceTests_count}">
                                    <a defer-tooltip="${message(code: 'todo.is.ui.acceptanceTests')}">
                                        <i class="fa" ng-class="storyPreview.acceptanceTests_count ? 'fa-check-square' : 'fa-check-square-o'"></i>
                                        <span class="badge">{{ storyPreview.acceptanceTests_count || '' }}</span>
                                    </a>
                                </span>
                                <span class="action">
                                    <a>
                                        <i class="fa fa-ellipsis-h"></i>
                                    </a>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <form ng-if="authorizedStory('create')"
                  ng-submit="save(story, false)"
                  name='formHolder.storyForm'
                  novalidate>
                <div class="clearfix no-padding">
                    <div class="form-half">
                        <label for="name">${message(code: 'is.story.name')}</label>
                        <input required
                               name="name"
                               type="text"
                               class="form-control"
                               autofocus
                               placeholder="${message(code: 'is.ui.story.noname')}"
                               ng-maxlength="100"
                               ng-model="story.name"
                               ng-change="findDuplicates(story.name)"/>
                    </div>
                    <entry:point id="story-new-form"/>
                </div>
                <div class="clearfix no-padding">
                    <div ng-if="authorizedStory('createAccepted')"
                         class="form-half">
                        <label for="state">${message(code: 'is.story.state')}</label>
                        <ui-select name="story.state"
                                   required
                                   class="form-control"
                                   ng-model="story.state">
                            <ui-select-match>{{ $select.selected | i18n:'StoryStates' }}</ui-select-match>
                            <ui-select-choices repeat="storyState in newStoryStates">{{ ::storyState | i18n:'StoryStates' }}</ui-select-choices>
                        </ui-select>
                    </div>
                    <div class="form-half">
                        <label for="feature">${message(code: 'is.feature')}</label>
                        <ui-select class="form-control"
                                   name="feature"
                                   search-enabled="true"
                                   ng-change="featureChanged()"
                                   ng-disabled="formHolder.featureDisabled"
                                   ng-model="story.feature">
                            <ui-select-match allow-clear="true" placeholder="${message(code: 'is.ui.story.nofeature')}">
                                <i class="fa fa-sticky-note" ng-style="{color: $select.selected.color}"></i> {{ $select.selected.name }}
                            </ui-select-match>
                            <ui-select-choices repeat="feature in features | orFilter: { name: $select.search, uid: $select.search }">
                                <i class="fa fa-sticky-note" ng-style="{color: feature.color}"></i> <span ng-bind-html="feature.name | highlight: $select.search"></span>
                            </ui-select-choices>
                        </ui-select>
                    </div>
                </div>
                <div style="margin-top:0;margin-bottom:10px;padding:5px;" ng-if="messageDuplicate"
                     class="help-block bg-warning spaced-help-block"
                     ng-bind-html="messageDuplicate"></div>
                <div class="clearfix">
                    <div class="btn-toolbar pull-right">
                        <button class="btn btn-primary"
                                ng-disabled="formHolder.storyForm.$invalid || application.submitting"
                                defer-tooltip="${message(code: 'todo.is.ui.create.and.continue')} (SHIFT+RETURN)"
                                hotkey="{'shift+return': hotkeyClick }"
                                hotkey-allow-in="INPUT"
                                hotkey-description="${message(code: 'todo.is.ui.create.and.continue')}"
                                type='button'
                                ng-click="save(story, true)">
                            ${message(code: 'todo.is.ui.create.and.continue')}
                        </button>
                        <button class="btn btn-primary"
                                ng-disabled="formHolder.storyForm.$invalid || application.submitting"
                                type="submit">
                            ${message(code: 'default.button.create.label')}
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
</script>
