/*
 * Copyright (c) 2016 Kagilum SAS.
 *
 * This file is part of iceScrum.
 *
 * iceScrum is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License.
 *
 * iceScrum is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 *
 * Vincent Barrier (vbarrier@kagilum.com)
 * Nicolas Noullet (nnoullet@kagilum.com)
 *
 */

services.factory('Widget', ['Resource', function($resource) {
    return $resource('/ui/widget/:widgetDefinitionId/:id');
}]);

services.service("WidgetService", ['CacheService', '$q', 'Session', 'Widget', function(CacheService, $q, Session, Widget) {
    Session.widgets = CacheService.getCache('widget');
    this.list = function() {
        var widgets = CacheService.getCache('widget');
        return _.isEmpty(widgets) ? Widget.query().$promise.then(function(widgets) {
            _.each(widgets, function(widget) {
                CacheService.addOrUpdate('widget', widget);
            });
            return CacheService.getCache('widget');
        }) : $q.when(widgets);
    };
    this.update = function(widget) {
        widget.class = 'widget';
        return widget.$update({widgetDefinitionId: widget.widgetDefinitionId, id: widget.id}, function(widget) {
            CacheService.addOrUpdate('widget', widget);
        }).$promise;
    };
    this['delete'] = function(widget) {
        return widget.$delete({widgetDefinitionId: widget.widgetDefinitionId, id: widget.id}, function() {
            CacheService.remove('widget', widget.id);
        }).$promise;
    };
}]);
