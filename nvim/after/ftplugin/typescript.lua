local opts = { buffer = 0 }

vim.snippet.add("desc", [[
describe('${1}', () => {
    ${2}
});
]], opts)

vim.snippet.add("its", [[
it('${1}', () => {
    ${2}
});
]], opts)

vim.snippet.add("its", [[
it('${1}', () => {
    ${2}
});
]], opts)

vim.snippet.add("ita", [[
it('${1}', async () => {
    ${2}
});
]], opts)

vim.snippet.add("itf", [[
it('${1}', () => {
    const fixture = factory();
    ${3}
});
]], opts)

vim.snippet.add("tests", [[
import { TestBed } from '@angular/core/testing';

describe('${1}', () => {
    let service: ${2};

    beforeEach(() => {
        TestBed.configureTestingModule({
            providers: [${2}]
        });

        service = TestBed.inject(${2});
    });

    it('should create', () => {
        expect(service).toBeTruthy();
    });
});
]], opts)

vim.snippet.add("testc", [[
import { TestBed } from '@angular/core/testing';
import { MockInstance, MockRenderFactory } from 'ng-mocks';

describe('${1}', () => {
    MockInstance.scope();

    const factory = MockRenderFactory(${2}, []);

    beforeEach(async () => {
        TestBed.configureTestingModule({
            declarations: [${2}]
        }).compileComponents();

        factory.configureTestBed();
    });

    it('should create', () => {
        const fixture = factory(),
            { componentInstance: component } = fixture.point;

        expect(component).toBeTruthy();
    });
});
]], opts)

vim.snippet.add("angs", [[
import { Injectable } from '@angular/core';

@Injectable({ providedIn: ${1:'root'} })
export class ${2:ServiceName}Service {
    constructor() { }
}
]], opts)

vim.snippet.add("angc", [[
import { Component, OnInit } from '@angular/core';

@Component({
    selector: '${1:selector-name}',
    templateUrl: '${2:name}.component.html'
})
export class ${3:Name}Component implements OnInit {
    constructor() { }
}
]], opts)

vim.snippet.add("angp", [[
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
    name: '${1:selector-name}'
})
export class ${2:Name}Pipe implements PipeTransform {
    transform(value: any, ...args: any[]): any {
        $0
    }
}
]], opts)
