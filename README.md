# Luna

> A modern Plone Distribution powered by Plone Seven and Nick CMS

[![npm](https://img.shields.io/npm/v/@lunaspace/luna)](https://www.npmjs.com/package/@lunaspace/luna)
[![](https://img.shields.io/badge/-Storybook-ff4785?logo=Storybook&logoColor=white&style=flat-square)](https://LunaSpaceDev.github.io/luna/)
[![Code analysis checks](https://github.com/LunaSpaceDev/luna/actions/workflows/code.yml/badge.svg)](https://github.com/LunaSpaceDev/luna/actions/workflows/code.yml)
[![Unit tests](https://github.com/LunaSpaceDev/luna/actions/workflows/unit.yml/badge.svg)](https://github.com/LunaSpaceDev/luna/actions/workflows/unit.yml)

Luna is a modern, high-performance Plone distribution that combines the power of [Plone Seven](https://github.com/plone/volto/tree/seven) — the latest React-based frontend for Plone — with [Nick CMS](https://nickcms.org/), a blazing-fast headless CMS built on Node.js and PostgreSQL.

## What is Luna?

Luna represents the next generation of content management by bringing together:

- **Volto Seven**: The cutting-edge React frontend for Plone featuring a modern block-based editor (Pastanaga), modular architecture, and extensive customization capabilities
- **Nick CMS**: A high-performance headless CMS built with Node.js, offering a RESTful hypermedia API, hierarchical content management, and enterprise-grade security

This combination delivers the flexibility and developer experience of modern JavaScript frameworks with the robustness and content management capabilities that Plone users expect.

## Key Features

- **Modern React Frontend**: Built on Volto Seven with the Pastanaga block-based editor
- **High Performance**: Nick CMS backend powered by Node.js and PostgreSQL for optimal speed
- **Seamless Integration**: Pre-configured to work with Nick CMS's API structure (no `++api++` prefix required)
- **Hierarchical Content**: Tree-based content structure that naturally maps to site navigation and URLs
- **Enterprise Security**: Comprehensive role-based access control, permissions, and workflow management
- **Content Versioning**: Full revision history and rollback capabilities
- **Internationalization**: Built-in i18n support for multilingual content
- **Extensible**: Leverage Volto's addon ecosystem to extend functionality
- **Developer Friendly**: Modern tooling with TypeScript, pnpm workspaces, and hot reloading

## Quick Start

### Prerequisites

Before you begin, ensure you have the following installed:

- [Node.js](https://nodejs.org/) (v20 or later)
- [pnpm](https://pnpm.io/) (v10.10.0 or later)
- [PostgreSQL](https://www.postgresql.org/) (for Nick CMS backend)
- [Docker](https://www.docker.com/) (optional, for containerized deployment)

### Installation (Nick backend)

> WORK IN PROGRESS - Skip it for now

1. **Set up Nick CMS backend**

Follow the [Nick CMS installation guide](https://nickcms.org/) to set up your backend server with PostgreSQL.

2. **Start the development server**

```bash
pnpm install
PLONE_API_PATH=http://localhost:8080 pnpm start
```

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/LunaSpaceDev/luna.git
cd luna
```

2. **Set up Plone backend**

```bash
make install-backend
make start-backend
```

3. **Set up Plone frontend**

```
make install-frontend
make start-frontend
```

3. **Set up Plone Seven**

```bash
make install-seven
make start-seven
```


5. **Access Luna**

Visit [http://localhost:3000](http://localhost:3000) in your browser to see Luna in action.

## Using Luna as an Add-on

You can also use Luna as an add-on in your existing Volto project:

### Add to your project

```bash
pnpm add @lunaspace/luna
```

### Configure in your project

Add `@lunaspace/luna` to your add-ons configuration:

```javascript
// registry.config.ts
import { addons } from '@plone/registry';

addons.push('@lunaspace/luna');

export { addons };
```

### Available Commands

Luna provides convenient `make` commands for common development tasks:

| Command | Description |
|---------|-------------|
| `make help` | Show all available commands |


### Code Quality

**Linting**

Run ESLint, Prettier, and Stylelint in analyze mode:

```bash
make lint
```

**Formatting**

Auto-fix code formatting issues:

```bash
make format
```

**Testing**

Run the test suite:

```bash
make test
```

### Internationalization

Extract and sync i18n messages:

```bash
make i18n
```

### Storybook

Luna uses Storybook to document and showcase components:

**Start Storybook development server:**

```bash
make storybook-start
```

**Build Storybook for production:**

```bash
make storybook-build
```

### How Luna Works with Nick CMS

Luna includes a custom server configuration (`packages/luna/config/server.ts`) that configures the Plone Client to work seamlessly with Nick CMS:

- Removes the `++api++` prefix requirement (Nick CMS uses direct API paths)
- Optimizes API communication for Nick CMS's hypermedia structure
- Maintains full compatibility with Volto Seven's features and conventions

## Contributing

We welcome contributions from the community! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Make your changes** and ensure tests pass
4. **Commit your changes** (`git commit -m 'Add amazing feature'`)
5. **Push to your fork** (`git push origin feature/amazing-feature`)
6. **Open a Pull Request**

### Development Guidelines

- Follow the existing code style (use `make format` to auto-format)
- Write tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting PR

## Community and Support

- **Issues**: [GitHub Issues](https://github.com/LunaSpaceDev/luna/issues)
- **Discussions**: [GitHub Discussions](https://github.com/LunaSpaceDev/luna/discussions)
- **Documentation**: [Luna Docs](https://LunaSpaceDev.github.io/luna/)

## Roadmap

- [ ] Enhanced Nick CMS integration features
- [ ] Additional Volto Seven block types
- [ ] Performance optimization suite
- [ ] Extended documentation and tutorials
- [ ] Example projects and starter templates

## Related Projects

- [Volto](https://github.com/plone/volto) - React-based frontend for Plone
- [Nick CMS](https://nickcms.org/) - High-performance headless CMS
- [Plone](https://plone.org/) - Enterprise-grade CMS

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits and Acknowledgements

Luna is built on the shoulders of giants. Special thanks to:

- The Plone community for decades of CMS innovation
- The Volto Seven team for the modern React frontend
- The Nick CMS team for the high-performance backend
- All contributors and supporters of the Luna project

---

Made with ❤️ by [Luna Space](https://github.com/LunaSpaceDev)
